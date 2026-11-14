package net.mathru.masamune_ai_debugger

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

/**
 * Captures the microphone as mono PCM16 (little endian) chunks of about
 * 100 ms at the sample rate requested by Dart (16 kHz when not given) and
 * passes them to [emit] from a background thread.
 *
 * Compiled only into builds with `MASAMUNE_AI_DEBUGGER_VOICE=true`.
 */
internal class MasamuneAIDebuggerVoice(
    private val emit: (ByteArray) -> Unit,
) : PluginRegistry.RequestPermissionsResultListener {
    companion object {
        const val AVAILABLE = true
        const val DEFAULT_SAMPLE_RATE = 16000
        private const val MIN_SAMPLE_RATE = 8000
        private const val MAX_SAMPLE_RATE = 48000
        private const val PERMISSION_REQUEST_CODE = 0x4d41
    }

    private var recorder: AudioRecord? = null
    private var thread: Thread? = null

    @Volatile
    private var running = false
    private var pendingResult: MethodChannel.Result? = null
    private var pendingSampleRate = DEFAULT_SAMPLE_RATE

    fun start(
        activity: Activity?,
        result: MethodChannel.Result,
        sampleRate: Int = DEFAULT_SAMPLE_RATE,
    ) {
        val rate = sampleRate.coerceIn(MIN_SAMPLE_RATE, MAX_SAMPLE_RATE)
        if (activity == null) {
            result.error("start_failed", "No activity is attached.", null)
            return
        }
        if (activity.checkSelfPermission(Manifest.permission.RECORD_AUDIO) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            begin(result, rate)
            return
        }
        pendingResult?.error("cancelled", "A newer permission request replaced this one.", null)
        pendingResult = result
        pendingSampleRate = rate
        activity.requestPermissions(
            arrayOf(Manifest.permission.RECORD_AUDIO),
            PERMISSION_REQUEST_CODE,
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean {
        if (requestCode != PERMISSION_REQUEST_CODE) return false
        val result = pendingResult ?: return true
        pendingResult = null
        if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            begin(result, pendingSampleRate)
        } else {
            result.error("permission_denied", "Microphone permission was denied.", null)
        }
        return true
    }

    @SuppressLint("MissingPermission")
    private fun begin(
        result: MethodChannel.Result,
        sampleRate: Int,
    ) {
        stop()
        // About 100 ms of PCM16.
        val chunkBytes = sampleRate * 2 / 10
        try {
            val minSize =
                AudioRecord.getMinBufferSize(
                    sampleRate,
                    AudioFormat.CHANNEL_IN_MONO,
                    AudioFormat.ENCODING_PCM_16BIT,
                )
            if (minSize <= 0) {
                result.error("start_failed", "The microphone input format is not supported.", null)
                return
            }
            val record =
                AudioRecord(
                    MediaRecorder.AudioSource.VOICE_RECOGNITION,
                    sampleRate,
                    AudioFormat.CHANNEL_IN_MONO,
                    AudioFormat.ENCODING_PCM_16BIT,
                    maxOf(minSize, chunkBytes) * 2,
                )
            if (record.state != AudioRecord.STATE_INITIALIZED) {
                record.release()
                result.error("start_failed", "The microphone could not be initialized.", null)
                return
            }
            record.startRecording()
            recorder = record
            running = true
            thread =
                Thread({ read(record, chunkBytes) }, "masamune_ai_debugger_voice").apply { start() }
            result.success(true)
        } catch (error: Exception) {
            stop()
            result.error("start_failed", error.message ?: error.toString(), null)
        }
    }

    private fun read(
        record: AudioRecord,
        chunkBytes: Int,
    ) {
        val buffer = ByteArray(chunkBytes)
        while (running) {
            var filled = 0
            while (running && filled < chunkBytes) {
                val count = record.read(buffer, filled, chunkBytes - filled)
                if (count < 0) {
                    running = false
                    break
                }
                filled += count
            }
            if (filled > 0) emit(buffer.copyOf(filled))
        }
    }

    fun stop() {
        running = false
        val record = recorder
        recorder = null
        try {
            record?.stop()
        } catch (_: IllegalStateException) {
        }
        thread?.join(500)
        thread = null
        record?.release()
    }
}
