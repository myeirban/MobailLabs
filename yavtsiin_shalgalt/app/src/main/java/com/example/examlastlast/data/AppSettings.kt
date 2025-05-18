package com.example.examlastlast.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "settings")

class AppSettings(private val context: Context) {
    private val dataStore = context.dataStore

    suspend fun getDisplayMode(): DisplayMode {
        return dataStore.data.collect { preferences ->
            when (preferences[PreferencesKeys.DISPLAY_MODE] ?: 0) {
                0 -> DisplayMode.BOTH
                1 -> DisplayMode.FOREIGN_ONLY
                2 -> DisplayMode.MONGOLIAN_ONLY
                else -> DisplayMode.BOTH
            }
        }
    }

    suspend fun setDisplayMode(mode: DisplayMode) {
        dataStore.edit { preferences ->
            preferences[PreferencesKeys.DISPLAY_MODE] = when (mode) {
                DisplayMode.BOTH -> 0
                DisplayMode.FOREIGN_ONLY -> 1
                DisplayMode.MONGOLIAN_ONLY -> 2
            }
        }
    }

    private object PreferencesKeys {
        val DISPLAY_MODE = intPreferencesKey("display_mode")
    }
} 