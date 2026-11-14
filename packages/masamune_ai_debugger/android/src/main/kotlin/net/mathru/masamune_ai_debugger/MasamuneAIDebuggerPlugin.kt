package net.mathru.masamune_ai_debugger

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Native side of masamune_ai_debugger.
 *
 * The microphone capture lives in `src/voice` and is compiled only when the
 * app is built with `--dart-define=MASAMUNE_AI_DEBUGGER_VOICE=true`.
 * Other builds use the stub in `src/novoice`, which references no audio API.
 */
class MasamuneAIDebuggerPlugin :
    FlutterPlugin,
    ActivityAware,
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var events: EventChannel
    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var activityBinding: ActivityPluginBinding? = null
    private val voice =
        MasamuneAIDebuggerVoice { bytes ->
            mainHandler.post { eventSink?.success(bytes) }
        }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "masamune_ai_debugger/voice")
        channel.setMethodCallHandler(this)
        events = EventChannel(binding.binaryMessenger, "masamune_ai_debugger/voice/audio")
        events.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        voice.stop()
        channel.setMethodCallHandler(null)
        events.setStreamHandler(null)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        when (call.method) {
            "isAvailable" -> result.success(MasamuneAIDebuggerVoice.AVAILABLE)
            "start" ->
                voice.start(
                    activityBinding?.activity,
                    result,
                    call.argument<Number>("sampleRate")?.toInt()
                        ?: MasamuneAIDebuggerVoice.DEFAULT_SAMPLE_RATE,
                )
            "stop" -> {
                voice.stop()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(
        arguments: Any?,
        sink: EventChannel.EventSink?,
    ) {
        eventSink = sink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addRequestPermissionsResultListener(voice)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeRequestPermissionsResultListener(voice)
        activityBinding = null
    }
}
