package com.example.exam.settings

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.exam.dataStore.SettingsDataStore
import kotlinx.coroutines.launch

class SettingsViewModel(application: Application) : AndroidViewModel(application) {

    private val settingsDataStore = SettingsDataStore(application)

    private fun SettingsDataStore(application: Application): SettingsDataStore {
            TODO("Not yet implemented")
    }

    val showForeignWord = settingsDataStore.showForeignWord
    val showMongolianWord = settingsDataStore.showMongolianWord

    fun setShowForeignWord(show: Boolean) {
        viewModelScope.launch {
            settingsDataStore.setShowForeignWord(show)
        }
    }

    fun setShowMongolianWord(show: Boolean) {
        viewModelScope.launch {
            settingsDataStore.setShowMongolianWord(show)
        }
    }

    fun saveForeignWord(foreignWord: String) {

    }

    fun saveMongolianWord(mongolianWord: String) {

    }

    fun saveLanguageSwitch(it: Boolean) {

    }
}
