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
 * Captures the microphone as 16 kHz mono PCM16 (little endian) chunks of
 * about 100 ms and passes them to [emit] from a background thread.
 *
 * Compiled only into builds with `MASAMUNE_AI_DEBUGGER_VOICE=true`.
 */
internal class MasamuneAIDebuggerVoice(
    private val emit: (ByteArray) -> Unit,
) : PluginRegistry.RequestPermissionsResultListener {
    companion object {
        const val AVAILABLE = true
        private const val SAMPLE_RATE = 16000
        private const val CHUNK_BYTES = 3200
        private const val PERMISSION_REQUEST_CODE = 0x4d41
    }

    private var recorder: AudioRecord? = null
    private var thread: Thread? = null

    @Volatile
    private var running = false
    private var pendingResult: MethodChannel.Result? = null

    fun start(
        activity: Activity?,
        result: MethodChannel.Result,
    ) {
        if (activity == null) {
            result.error("start_failed", "No activity is attached.", null)
            return
        }
        if (activity.checkSelfPermission(Manifest.permission.RECORD_AUDIO) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            begin(result)
            return
        }
        pendingResult?.error("cancelled", "A newer permission request replaced this one.", null)
        pendingResult = result
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
            begin(result)
        } else {
            result.error("permission_denied", "Microphone permission was denied.", null)
        }
        return true
    }

    @SuppressLint("MissingPermission")
    private fun begin(result: MethodChannel.Result) {
        stop()
        try {
            val minSize =
                AudioRecord.getMinBufferSize(
                    SAMPLE_RATE,
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
                    SAMPLE_RATE,
                    AudioFormat.CHANNEL_IN_MONO,
                    AudioFormat.ENCODING_PCM_16BIT,
                    maxOf(minSize, CHUNK_BYTES) * 2,
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
                Thread({ read(record) }, "masamune_ai_debugger_voice").apply { start() }
            result.success(true)
        } catch (error: Exception) {
            stop()
            result.error("start_failed", error.message ?: error.toString(), null)
        }
    }

    private fun read(record: AudioRecord) {
        val buffer = ByteArray(CHUNK_BYTES)
        while (running) {
            var filled = 0
            while (running && filled < CHUNK_BYTES) {
                val count = record.read(buffer, filled, CHUNK_BYTES - filled)
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
