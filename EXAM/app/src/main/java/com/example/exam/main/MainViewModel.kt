package com.example.exam.main

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.exam.data.WordEntity
import com.example.exam.data.WordRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MainViewModel(
    application: Application,
    private val wordRepository: WordRepository
) : AndroidViewModel(application) {

    private val _words = MutableStateFlow<List<WordEntity>>(emptyList())
    val words: StateFlow<List<WordEntity>> = _words

    init {
        viewModelScope.launch {
            wordRepository.getAllWords().collect { wordList ->
                _words.value = wordList
            }
        }
    }

    fun addWord(word: WordEntity) {
        viewModelScope.launch {
            wordRepository.insertWord(word)
        }
    }

    fun deleteWord(word: WordEntity) {
        viewModelScope.launch {
            wordRepository.deleteWord(word)
        }
    }

    fun updateWord(word: WordEntity) {
        viewModelScope.launch {
            wordRepository.updateWord(word)
        }
    }

    class Factory(
        private val application: Application,
        private val repository: WordRepository
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T {
            if (modelClass.isAssignableFrom(MainViewModel::class.java)) {
                return MainViewModel(application, repository) as T
            }
            throw IllegalArgumentException("Unknown ViewModel class")
        }
    }
}
