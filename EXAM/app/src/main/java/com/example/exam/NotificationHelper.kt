package com.example.exam

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat

object NotificationHelper {

    private const val CHANNEL_ID = "word_notification_channel"

    fun showNotification(context: Context) {
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Notification Channel
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Word Notifications",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            notificationManager.createNotificationChannel(channel)
        }

        // Notification
        val notification: Notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle("Тохиргоо")
            .setContentText("Таны апп шинэчлэгдсэн байна!")
            .setSmallIcon(R.drawable.ic_notification)
            .build()

        notificationManager.notify(1, notification)
    }
}
