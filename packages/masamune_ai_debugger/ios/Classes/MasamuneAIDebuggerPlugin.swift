import Flutter
import UIKit

/// Native side of masamune_ai_debugger.
///
/// The microphone capture is compiled only with `-DMASAMUNE_AI_DEBUGGER_VOICE`
/// (see the podspec). Without the flag no audio API is referenced and every
/// voice call fails with `unavailable`.
public class MasamuneAIDebuggerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private static let methodChannelName = "masamune_ai_debugger/voice"
  private static let eventChannelName = "masamune_ai_debugger/voice/audio"

  private var eventSink: FlutterEventSink?

  #if MASAMUNE_AI_DEBUGGER_VOICE
  private lazy var capture = MasamuneAIDebuggerVoiceCapture { [weak self] data in
    self?.eventSink?(FlutterStandardTypedData(bytes: data))
  }
  #endif

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = MasamuneAIDebuggerPlugin()
    let channel = FlutterMethodChannel(
      name: methodChannelName,
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(instance, channel: channel)
    let events = FlutterEventChannel(
      name: eventChannelName,
      binaryMessenger: registrar.messenger()
    )
    events.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      #if MASAMUNE_AI_DEBUGGER_VOICE
      result(true)
      #else
      result(false)
      #endif
    case "start":
      #if MASAMUNE_AI_DEBUGGER_VOICE
      capture.start(result: result, sampleRate: Self.sampleRate(of: call.arguments))
      #else
      result(Self.unavailable())
      #endif
    case "stop":
      #if MASAMUNE_AI_DEBUGGER_VOICE
      capture.stop()
      #endif
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  /// Sample rate requested by Dart (`{"sampleRate": 24000}`), 16 kHz when absent.
  private static func sampleRate(of arguments: Any?) -> Double {
    guard
      let map = arguments as? [String: Any],
      let value = map["sampleRate"] as? NSNumber,
      value.doubleValue > 0
    else {
      return 16000
    }
    return min(max(value.doubleValue, 8000), 48000)
  }

  private static func unavailable() -> FlutterError {
    FlutterError(
      code: "unavailable",
      message: "Voice input is not compiled. Build with FLUTTER_XCODE_MASAMUNE_AI_DEBUGGER_VOICE=YES.",
      details: nil
    )
  }
}

#if MASAMUNE_AI_DEBUGGER_VOICE
import AVFoundation

/// Captures the microphone as mono PCM16 (little endian) chunks of about
/// 100 ms at the requested sample rate.
final class MasamuneAIDebuggerVoiceCapture {
  private var sampleRate: Double = 16000
  /// About 100 ms of PCM16 at `sampleRate`.
  private var chunkBytes = 3200

  private let emit: (Data) -> Void
  private var engine: AVAudioEngine?
  private var converter: AVAudioConverter?
  private var pending = Data()
  private var previousCategory: AVAudioSession.Category?
  private var previousMode: AVAudioSession.Mode?
  private var previousOptions: AVAudioSession.CategoryOptions?

  init(emit: @escaping (Data) -> Void) {
    self.emit = emit
  }

  func start(result: @escaping FlutterResult, sampleRate: Double = 16000) {
    let handler: (Bool) -> Void = { granted in
      DispatchQueue.main.async {
        guard granted else {
          result(FlutterError(
            code: "permission_denied",
            message: "Microphone permission was denied.",
            details: nil
          ))
          return
        }
        self.begin(result: result, sampleRate: sampleRate)
      }
    }
    if #available(iOS 17.0, *) {
      AVAudioApplication.requestRecordPermission(completionHandler: handler)
    } else {
      AVAudioSession.sharedInstance().requestRecordPermission(handler)
    }
  }

  func stop() {
    if let engine = engine {
      engine.inputNode.removeTap(onBus: 0)
      engine.stop()
    }
    engine = nil
    converter = nil
    if !pending.isEmpty {
      emit(pending)
      pending = Data()
    }
    restoreSession()
  }

  private func begin(result: @escaping FlutterResult, sampleRate: Double) {
    stop()
    self.sampleRate = sampleRate
    chunkBytes = Int(sampleRate / 10) * MemoryLayout<Int16>.size
    do {
      let session = AVAudioSession.sharedInstance()
      previousCategory = session.category
      previousMode = session.mode
      previousOptions = session.categoryOptions
      try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
      try session.setActive(true)

      let engine = AVAudioEngine()
      let input = engine.inputNode
      let inputFormat = input.outputFormat(forBus: 0)
      guard
        inputFormat.sampleRate > 0,
        let outputFormat = AVAudioFormat(
          commonFormat: .pcmFormatInt16,
          sampleRate: sampleRate,
          channels: 1,
          interleaved: true
        ),
        let converter = AVAudioConverter(from: inputFormat, to: outputFormat)
      else {
        restoreSession()
        result(FlutterError(
          code: "start_failed",
          message: "The microphone input format is not supported.",
          details: nil
        ))
        return
      }
      let bufferSize = AVAudioFrameCount(inputFormat.sampleRate / 10)
      input.installTap(onBus: 0, bufferSize: bufferSize, format: inputFormat) {
        [weak self] buffer, _ in
        self?.convert(buffer, converter: converter, outputFormat: outputFormat)
      }
      engine.prepare()
      try engine.start()
      self.engine = engine
      self.converter = converter
      result(true)
    } catch {
      stop()
      result(FlutterError(
        code: "start_failed",
        message: error.localizedDescription,
        details: nil
      ))
    }
  }

  private func convert(
    _ buffer: AVAudioPCMBuffer,
    converter: AVAudioConverter,
    outputFormat: AVAudioFormat
  ) {
    let ratio = outputFormat.sampleRate / buffer.format.sampleRate
    let capacity = AVAudioFrameCount(Double(buffer.frameLength) * ratio) + 32
    guard let output = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: capacity) else {
      return
    }
    var supplied = false
    var error: NSError?
    let status = converter.convert(to: output, error: &error) { _, inputStatus in
      if supplied {
        inputStatus.pointee = .noDataNow
        return nil
      }
      supplied = true
      inputStatus.pointee = .haveData
      return buffer
    }
    guard status != .error, error == nil, output.frameLength > 0,
          let channel = output.int16ChannelData else {
      return
    }
    let data = Data(
      bytes: channel[0],
      count: Int(output.frameLength) * MemoryLayout<Int16>.size
    )
    DispatchQueue.main.async { [weak self] in
      self?.append(data)
    }
  }

  private func append(_ data: Data) {
    guard engine != nil else { return }
    pending.append(data)
    while pending.count >= chunkBytes {
      emit(Data(pending.prefix(chunkBytes)))
      pending.removeFirst(chunkBytes)
    }
  }

  private func restoreSession() {
    guard let category = previousCategory else { return }
    let session = AVAudioSession.sharedInstance()
    try? session.setActive(false, options: .notifyOthersOnDeactivation)
    try? session.setCategory(
      category,
      mode: previousMode ?? .default,
      options: previousOptions ?? []
    )
    previousCategory = nil
    previousMode = nil
    previousOptions = nil
  }
}
#endif
