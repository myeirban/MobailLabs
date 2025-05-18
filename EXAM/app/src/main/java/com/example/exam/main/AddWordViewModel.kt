package com.example.exam.main

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.exam.data.WordEntity
import com.example.exam.data.WordRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

class AddWordViewModel(
    application: Application,
    private val repository: WordRepository
) : AndroidViewModel(application) {

    private val _uiState = MutableStateFlow<AddWordUiState>(AddWordUiState.Idle)
    val uiState: StateFlow<AddWordUiState> = _uiState

    fun addWord(word: WordEntity) {
        repository.insertWord(word)
    }

    class Factory(
        private val application: Application,
        private val repository: WordRepository
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            if (modelClass.isAssignableFrom(AddWordViewModel::class.java)) {
                return AddWordViewModel(application, repository) as T
            }
            throw IllegalArgumentException("Unknown ViewModel class")
        }
    }
}

sealed class AddWordUiState {
    object Idle : AddWordUiState()
    object Loading : AddWordUiState()
    object Success : AddWordUiState()
    data class Error(val message: String) : AddWordUiState()
} 