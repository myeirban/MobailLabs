package com.example.examlastlast.data

import android.content.Context
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class SettingsRepository(context: Context) {
    private val appSettings = AppSettings(context)

    val displayMode: Flow<DisplayMode> = appSettings.getDisplayMode()

    suspend fun setDisplayMode(mode: DisplayMode) {
        appSettings.setDisplayMode(mode)
    }
} 