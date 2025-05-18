package com.example.exam.notifications

import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager

class NotificationScheduler(private val workManager: WorkManager) {

    fun scheduleNotification() {
        val notificationRequest = OneTimeWorkRequestBuilder<NotificationWorker>()
            .build()

        workManager.enqueue(notificationRequest)
    }
}
