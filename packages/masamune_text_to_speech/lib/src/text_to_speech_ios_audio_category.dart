part of '/masamune_text_to_speech.dart';

/// Audio session category identifiers for iOS.
///
/// iOSのオーディオセッションカテゴリ識別子。
///
/// See also:
/// * https://developer.apple.com/documentation/avfaudio/avaudiosession/category
enum TextToSpeechIosAudioCategory {
  /// The default audio session category.
  ///
  /// Your audio is silenced by screen locking and by the Silent switch.
  ///
  /// By default, using this category implies that your app’s audio
  /// is nonmixable—activating your session will interrupt
  /// any other audio sessions which are also nonmixable.
  /// To allow mixing, use the [ambient] category instead.
  ///
  /// デフォルトのオーディオセッションカテゴリ。
  ///
  /// 画面ロックやサイレントスイッチによって音声が消音されます。
  ///
  /// デフォルトでは、このカテゴリを使用すると、アプリのオーディオがミキシングできないことを意味します。
  /// 他のオーディオセッションもミキシングできない場合、セッションをアクティブにすると中断されます。
  /// ミキシングを許可するには、代わりに[ambient]カテゴリを使用してください。
  ambientSolo,

  /// The category for an app in which sound playback is nonprimary — that is,
  /// your app also works with the sound turned off.
  ///
  /// This category is also appropriate for “play-along” apps,
  /// such as a virtual piano that a user plays while the Music app is playing.
  /// When you use this category, audio from other apps mixes with your audio.
  /// Screen locking and the Silent switch (on iPhone, the Ring/Silent switch) silence your audio.
  ///
  /// 音声再生が非主要なアプリのカテゴリーです。
  /// つまり、アプリが音声をオフにしても動作するアプリです。
  ///
  /// このカテゴリは、「一緒に演奏する」アプリにも適しています。
  /// たとえば、ユーザーが音楽アプリが再生されている間に演奏する仮想ピアノなどです。
  /// このカテゴリを使用すると、他のアプリのオーディオがあなたのオーディオとミックスされます。
  /// 画面ロックやサイレントスイッチ（iPhoneの場合、リング/サイレントスイッチ）で音声が消音されます。
  ambient,

  /// The category for playing recorded music or other sounds
  /// that are central to the successful use of your app.
  ///
  /// When using this category, your app audio continues
  /// with the Silent switch set to silent or when the screen locks.
  ///
  /// By default, using this category implies that your app’s audio
  /// is nonmixable—activating your session will interrupt
  /// any other audio sessions which are also nonmixable.
  /// To allow mixing for this category, use the
  /// [TextToSpeechIosAudioCategoryOptions.mixWithOthers] option.
  ///
  /// アプリの成功に不可欠な録音された音楽やその他の音を再生するカテゴリ。
  ///
  /// このカテゴリを使用すると、アプリのオーディオは、サイレントスイッチがサイレントに設定されている場合や画面がロックされている場合でも続行されます。
  ///
  /// デフォルトでは、このカテゴリを使用すると、アプリのオーディオがミキシングできないことを意味します。
  /// 他のオーディオセッションもミキシングできない場合、セッションをアクティブにすると中断されます。
  /// このカテゴリのミキシングを許可するには、[TextToSpeechIosAudioCategoryOptions.mixWithOthers]オプションを使用してください。
  playback,

  /// The category for recording (input) and playback (output) of audio,
  /// such as for a Voice over Internet Protocol (VoIP) app.
  ///
  /// Your audio continues with the Silent switch set to silent and with the screen locked.
  /// This category is appropriate for simultaneous recording and playback,
  /// and also for apps that record and play back, but not simultaneously.
  ///
  /// 音声の録音（入力）と再生（出力）のためのカテゴリ。
  ///
  /// たとえば、インターネットプロトコル（VoIP）アプリなどです。
  ///
  /// サイレントスイッチがサイレントに設定されている場合や画面がロックされている場合でも、オーディオは続行されます。
  /// このカテゴリは、同時録音と再生に適しています。
  /// また、同時に録音と再生するアプリや、録音と再生を行うが同時に行わないアプリにも適しています。
  playAndRecord;

  IosTextToSpeechAudioCategory _toIosTextToSpeechAudioCategory() {
    switch (this) {
      case TextToSpeechIosAudioCategory.ambientSolo:
        return IosTextToSpeechAudioCategory.ambientSolo;
      case TextToSpeechIosAudioCategory.ambient:
        return IosTextToSpeechAudioCategory.ambient;
      case TextToSpeechIosAudioCategory.playback:
        return IosTextToSpeechAudioCategory.playback;
      case TextToSpeechIosAudioCategory.playAndRecord:
        return IosTextToSpeechAudioCategory.playAndRecord;
    }
  }
}

/// Audio session category options for iOS.
///
/// iOSのオーディオセッションカテゴリオプション。
///
/// See also:
/// * https://developer.apple.com/documentation/avfaudio/avaudiosession/categoryoptions
enum TextToSpeechIosAudioCategoryOptions {
  /// An option that indicates whether audio from this session mixes with audio
  /// from active sessions in other audio apps.
  ///
  /// You can set this option explicitly only if the audio session category
  /// is [TextToSpeechIosAudioCategory.playAndRecord] or
  /// [TextToSpeechIosAudioCategory.playback].
  /// If you set the audio session category to [TextToSpeechIosAudioCategory.ambient],
  /// the session automatically sets this option.
  /// Likewise, setting the [duckOthers] or [interruptSpokenAudioAndMixWithOthers]
  /// options also enables this option.
  ///
  /// If you set this option, your app mixes its audio with audio playing
  /// in background apps, such as the Music app.
  ///
  /// このセッションのオーディオを他のオーディオ アプリのアクティブなセッションのオーディオとミックスするかどうかを示すオプションです。
  ///
  /// このオプションを明示的に設定できるのは、オーディオセッションのカテゴリが[TextToSpeechIosAudioCategory.playAndRecord]または[TextToSpeechIosAudioCategory.playback]の場合のみです。
  /// オーディオセッションのカテゴリを[TextToSpeechIosAudioCategory.ambient]に設定すると、セッションはこのオプションを自動的に設定します。
  /// 同様に、[duckOthers]または[interruptSpokenAudioAndMixWithOthers]オプションを設定すると、このオプションも有効になります。
  ///
  /// このオプションを設定すると、アプリはバックグラウンドアプリ（たとえば、音楽アプリ）で再生されているオーディオとオーディオをミックスします。
  mixWithOthers,

  /// An option that reduces the volume of other audio sessions while audio
  /// from this session plays.
  ///
  /// You can set this option only if the audio session category is
  /// [TextToSpeechIosAudioCategory.playAndRecord] or
  /// [TextToSpeechIosAudioCategory.playback].
  /// Setting it implicitly sets the [mixWithOthers] option.
  ///
  /// Use this option to mix your app’s audio with that of others.
  /// While your app plays its audio, the system reduces the volume of other
  /// audio sessions to make yours more prominent. If your app provides
  /// occasional spoken audio, such as in a turn-by-turn navigation app
  /// or an exercise app, you should also set the [interruptSpokenAudioAndMixWithOthers] option.
  ///
  /// Note that ducking begins when you activate your app’s audio session
  /// and ends when you deactivate the session.
  ///
  /// このセッションのオーディオが再生されている間、他のオーディオセッションの音量を下げるオプションです。
  ///
  /// このオプションを設定できるのは、オーディオセッションのカテゴリが[TextToSpeechIosAudioCategory.playAndRecord]または[TextToSpeechIosAudioCategory.playback]の場合のみです。
  /// このオプションを設定すると、暗黙的に[mixWithOthers]オプションが設定されます。
  ///
  /// このオプションを使用して、アプリのオーディオを他のオーディオとミックスします。
  /// アプリがオーディオを再生している間、システムは他のオーディオセッションの音量を下げて、あなたのオーディオをより目立たせます。
  /// アプリがたまに音声を提供する場合（たとえば、ターンバイターンのナビゲーションアプリやエクササイズアプリなど）、[interruptSpokenAudioAndMixWithOthers]オプションも設定する必要があります。
  ///
  /// ダッキングは、アプリのオーディオセッションをアクティブにすると開始し、セッションを非アクティブにすると終了します。
  duckOthers,

  /// An option that determines whether to pause spoken audio content
  /// from other sessions when your app plays its audio.
  ///
  /// You can set this option only if the audio session category is
  /// [TextToSpeechIosAudioCategory.playAndRecord] or
  /// [TextToSpeechIosAudioCategory.playback].
  /// Setting this option also sets [mixWithOthers].
  ///
  /// If you set this option, the system mixes your audio with other
  /// audio sessions, but interrupts (and stops) audio sessions that use the
  /// [IosTextToSpeechAudioMode.spokenAudio] audio session mode.
  /// It pauses the audio from other apps as long as your session is active.
  /// After your audio session deactivates, the system resumes the interrupted app’s audio.
  ///
  /// Set this option if your app’s audio is occasional and spoken,
  /// such as in a turn-by-turn navigation app or an exercise app.
  /// This avoids intelligibility problems when two spoken audio apps mix.
  /// If you set this option, also set the [duckOthers] option unless
  /// you have a specific reason not to. Ducking other audio, rather than
  /// interrupting it, is appropriate when the other audio isn’t spoken audio.
  ///
  /// アプリがオーディオを再生している間、他のセッションからの音声オーディオコンテンツを一時停止するかどうかを決定するオプションです。
  ///
  /// このオプションを設定できるのは、オーディオセッションのカテゴリが[TextToSpeechIosAudioCategory.playAndRecord]または[TextToSpeechIosAudioCategory.playback]の場合のみです。
  /// このオプションを設定すると、[mixWithOthers]も設定されます。
  ///
  /// このオプションを設定すると、システムは他のオーディオセッションのオーディオをミックスしますが、[IosTextToSpeechAudioMode.spokenAudio]オーディオセッションモードを使用するオーディオセッションを中断（および停止）します。
  /// セッションがアクティブな間、他のアプリのオーディオを一時停止します。
  /// オーディオセッションが非アクティブになると、システムは中断されたアプリのオーディオを再開します。
  /// アプリのオーディオがたまに話される場合（たとえば、ターンバイターンのナビゲーションアプリやエクササイズアプリなど）、このオプションを設定します。
  /// 2つの話されるオーディオアプリがミックスされると、理解できない問題が発生するのを回避します。
  ///
  /// このオプションを設定する場合は、特定の理由がない限り、[duckOthers]オプションも設定してください。
  /// 他のオーディオをダッキングすることは、中断するのではなく、他のオーディオが話されるオーディオでない場合に適しています。
  interruptSpokenAudioAndMixWithOthers,

  /// An option that determines whether Bluetooth hands-free devices appear
  /// as available input routes.
  ///
  /// You can set this option only if the audio session category is
  /// [TextToSpeechIosAudioCategory.playAndRecord] or
  /// [TextToSpeechIosAudioCategory.playback].
  ///
  /// You’re required to set this option to allow routing audio input and output
  /// to a paired Bluetooth Hands-Free Profile (HFP) device.
  /// If you clear this option, paired Bluetooth HFP devices don’t show up
  /// as available audio input routes.
  ///
  /// Bluetoothハンズフリーデバイスが利用可能な入力ルートとして表示されるかどうかを決定するオプションです。
  ///
  /// オーディオセッションのカテゴリが[TextToSpeechIosAudioCategory.playAndRecord]または[TextToSpeechIosAudioCategory.playback]の場合のみ、このオプションを設定できます。
  ///
  /// オーディオ入力と出力をペアリングされたBluetooth Hands-Free Profile（HFP）デバイスにルーティングするには、このオプションを設定する必要があります。
  /// このオプションをクリアすると、ペアリングされたBluetooth HFPデバイスは利用可能なオーディオ入力ルートとして表示されません。
  allowBluetooth,

  /// An option that determines whether you can stream audio from this session
  /// to Bluetooth devices that support the Advanced Audio Distribution Profile (A2DP).
  ///
  /// A2DP is a stereo, output-only profile intended for higher bandwidth
  /// audio use cases, such as music playback.
  /// The system automatically routes to A2DP ports if you configure an
  /// app’s audio session to use the [TextToSpeechIosAudioCategory.ambient],
  /// [TextToSpeechIosAudioCategory.ambientSolo], or
  /// [TextToSpeechIosAudioCategory.playback] categories.
  ///
  /// Starting with iOS 10.0, apps using the
  /// [TextToSpeechIosAudioCategory.playAndRecord] category may also allow
  /// routing output to paired Bluetooth A2DP devices. To enable this behavior,
  /// pass this category option when setting your audio session’s category.
  ///
  /// Note: If this option and the [allowBluetooth] option are both set,
  /// when a single device supports both the Hands-Free Profile (HFP) and A2DP,
  /// the system gives hands-free ports a higher priority for routing.
  ///
  /// このセッションからBluetoothデバイスにオーディオをストリーミングできるかどうかを決定するオプションです。
  ///
  /// A2DPは、音楽再生などの帯域幅の高いオーディオユースケース向けのステレオ出力専用プロファイルです。
  /// システムは、アプリのオーディオセッションを[TextToSpeechIosAudioCategory.ambient]、[TextToSpeechIosAudioCategory.ambientSolo]、または[TextToSpeechIosAudioCategory.playback]カテゴリに設定すると、自動的にA2DPポートにルーティングします。
  ///
  /// iOS 10.0以降、[TextToSpeechIosAudioCategory.playAndRecord]カテゴリを使用するアプリは、ペアリングされたBluetooth A2DPデバイスに出力をルーティングすることもできます。この動作を有効にするには、オーディオセッションのカテゴリを設定するときにこのカテゴリオプションを渡します。
  ///
  /// 注：このオプションと[allowBluetooth]オプションの両方が設定されている場合、単一のデバイスがHands-Free Profile（HFP）とA2DPの両方をサポートしている場合、システムはハンズフリーポートをルーティングの優先度が高いものとして与えます。
  allowBluetoothA2DP,

  /// An option that determines whether you can stream audio
  /// from this session to AirPlay devices.
  ///
  /// Setting this option enables the audio session to route audio output
  /// to AirPlay devices. You can only explicitly set this option if the
  /// audio session’s category is set to [TextToSpeechIosAudioCategory.playAndRecord].
  /// For most other audio session categories, the system sets this option implicitly.
  ///
  /// このセッションからオーディオをAirPlayデバイスにストリーミングできるかどうかを決定するオプションです。
  ///
  /// このオプションを設定すると、オーディオセッションはオーディオ出力をAirPlayデバイスにルーティングできるようになります。
  /// オーディオセッションのカテゴリが[TextToSpeechIosAudioCategory.playAndRecord]に設定されている場合のみ、このオプションを明示的に設定できます。
  allowAirPlay,

  /// An option that determines whether audio from the session defaults to the built-in speaker instead of the receiver.
  ///
  /// You can set this option only when using the
  /// [TextToSpeechIosAudioCategory.playAndRecord] category.
  /// It’s used to modify the category’s routing behavior so that audio
  /// is always routed to the speaker rather than the receiver if
  /// no other accessories, such as headphones, are in use.
  ///
  /// When using this option, the system honors user gestures.
  /// For example, plugging in a headset causes the route to change to
  /// headset mic/headphones, and unplugging the headset causes the route
  /// to change to built-in mic/speaker (as opposed to built-in mic/receiver)
  /// when you’ve set this override.
  ///
  /// In the case of using a USB input-only accessory, audio input
  /// comes from the accessory, and the system routes audio to the headphones,
  /// if attached, or to the speaker if the headphones aren’t plugged in.
  /// The use case is to route audio to the speaker instead of the receiver
  /// in cases where the audio would normally go to the receiver.
  ///
  /// セッションからのオーディオが受信機ではなくビルトインスピーカーにデフォルトでルーティングされるかどうかを決定するオプションです。
  ///
  /// このオプションは、[TextToSpeechIosAudioCategory.playAndRecord]カテゴリを使用している場合にのみ設定できます。
  /// このオプションは、オーディオが他のアクセサリ（ヘッドフォンなど）を使用していない場合、常にスピーカーにルーティングされるようにカテゴリのルーティング動作を変更するために使用されます。
  ///
  /// このオプションを使用する場合、システムはユーザージェスチャを尊重します。
  /// たとえば、ヘッドセットを接続すると、ルートがヘッドセットマイク/ヘッドフォンに変更され、ヘッドセットを取り外すと、ビルトインマイク/スピーカーにルートが変更されます（ビルトインマイク/受信機ではなく）。
  ///
  /// USB入力専用アクセサリを使用する場合、オーディオ入力はアクセサリから行われ、システムはヘッドフォンが接続されている場合はヘッドフォンに、ヘッドフォンが接続されていない場合はスピーカーにオーディオをルーティングします。
  /// このユースケースは、通常オーディオが受信機に送信される場合に、オーディオを受信機の代わりにスピーカーにルーティングすることです。
  defaultToSpeaker;

  IosTextToSpeechAudioCategoryOptions _toIosTextToSpeechAudioCategoryOptions() {
    switch (this) {
      case TextToSpeechIosAudioCategoryOptions.mixWithOthers:
        return IosTextToSpeechAudioCategoryOptions.mixWithOthers;
      case TextToSpeechIosAudioCategoryOptions.duckOthers:
        return IosTextToSpeechAudioCategoryOptions.duckOthers;
      case TextToSpeechIosAudioCategoryOptions
          .interruptSpokenAudioAndMixWithOthers:
        return IosTextToSpeechAudioCategoryOptions
            .interruptSpokenAudioAndMixWithOthers;
      case TextToSpeechIosAudioCategoryOptions.allowBluetooth:
        return IosTextToSpeechAudioCategoryOptions.allowBluetooth;
      case TextToSpeechIosAudioCategoryOptions.allowBluetoothA2DP:
        return IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP;
      case TextToSpeechIosAudioCategoryOptions.allowAirPlay:
        return IosTextToSpeechAudioCategoryOptions.allowAirPlay;
      case TextToSpeechIosAudioCategoryOptions.defaultToSpeaker:
        return IosTextToSpeechAudioCategoryOptions.defaultToSpeaker;
    }
  }
}
