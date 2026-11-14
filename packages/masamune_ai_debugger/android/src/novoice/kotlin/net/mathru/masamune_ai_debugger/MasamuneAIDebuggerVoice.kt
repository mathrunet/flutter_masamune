package net.mathru.masamune_ai_debugger

import android.app.Activity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

/**
 * Stub used by builds without `MASAMUNE_AI_DEBUGGER_VOICE=true`.
 *
 * It references no audio API and requests no permission.
 */
internal class MasamuneAIDebuggerVoice(
    @Suppress("UNUSED_PARAMETER") emit: (ByteArray) -> Unit,
) : PluginRegistry.RequestPermissionsResultListener {
    companion object {
        const val AVAILABLE = false
        const val DEFAULT_SAMPLE_RATE = 16000
    }

    fun start(
        activity: Activity?,
        result: MethodChannel.Result,
        @Suppress("UNUSED_PARAMETER") sampleRate: Int = DEFAULT_SAMPLE_RATE,
    ) {
        result.error(
            "unavailable",
            "Voice input is not compiled. Build with --dart-define=MASAMUNE_AI_DEBUGGER_VOICE=true.",
            null,
        )
    }

    fun stop() {}

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean = false
}
