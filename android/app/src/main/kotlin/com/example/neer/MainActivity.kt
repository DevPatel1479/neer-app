package com.example.neer

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import android.os.Environment
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayInputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.neer/exif"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "processImage" -> {
                    val imageData: ByteArray? = call.argument("imageData")
                    if (imageData != null) {
                        val exifData = processImage(imageData)
                        result.success(exifData)
                    } else {
                        result.error("UNAVAILABLE", "Image data not available.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

private fun processImage(imageData: ByteArray): Map<String, String?> {
    val exifValues: MutableMap<String, String?> = mutableMapOf()

    try {
        // Decode the image data to Bitmap
        val originalBitmap: Bitmap? = BitmapFactory.decodeByteArray(imageData, 0, imageData.size)

        // Save the original bitmap to a file to read EXIF data
        val originalFile = getOutputMediaFile()
        originalFile?.let {
            FileOutputStream(it).use { fos ->
                originalBitmap?.compress(Bitmap.CompressFormat.JPEG, 100, fos)
                Log.d("ImageProcessing", "Original Picture saved: ${it.name}")
            }

            // Read the EXIF data from the original image
            val exif = ExifInterface(it.absolutePath)
            val exposureTime = exif.getAttribute(ExifInterface.TAG_EXPOSURE_TIME)
            val iso = exif.getAttribute(ExifInterface.TAG_ISO)

            // Add values to the map and log them for debugging
            exifValues["exposureTime"] = exposureTime
            exifValues["iso"] = iso
            Log.d("ImageProcessing", "Exposure Time: $exposureTime, ISO: $iso")  // Log EXIF values
        }

        // Optionally, you can still process the bitmap (rotate, scale, etc.)
        // Rotate the image by 90 degrees
        val matrix = Matrix().apply { postRotate(90.0f) }
        val rotatedBitmap = Bitmap.createBitmap(originalBitmap!!, 0, 0, originalBitmap.width, originalBitmap.height, matrix, true)

        // Scale down if height is greater than 2000 pixels
        if (rotatedBitmap.height > 2000) {
            Bitmap.createScaledBitmap(rotatedBitmap, rotatedBitmap.width / 2, rotatedBitmap.height / 2, false)
        }

        // Save the processed bitmap if needed
        // ...

    } catch (e: IOException) {
        Log.e("ImageProcessing", "Error processing image", e)
    }

    return exifValues // Return the map with EXIF values
}

    private fun getOutputMediaFile(): File? {
        // Create a storage directory if it doesn't exist
        val mediaStorageDir = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES), "YourApp")
        if (!mediaStorageDir.exists() && !mediaStorageDir.mkdirs()) {
            Log.d("YourApp", "failed to create directory")
            return null
        }
        // Create a media file
        val timeStamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
        return File(mediaStorageDir.path + File.separator + "IMG_$timeStamp.jpg")
    }
}
