package com.example.examlastlast

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.examlastlast.data.SettingsRepository
import com.example.examlastlast.data.WordRepository
import com.example.examlastlast.ui.WordViewModel

class ViewModelFactory(
    private val wordRepository: WordRepository,
    private val settingsRepository: SettingsRepository
) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(WordViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return WordViewModel(wordRepository, settingsRepository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
} 