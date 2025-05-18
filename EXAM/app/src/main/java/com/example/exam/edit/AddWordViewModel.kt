package com.example.exam.edit

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.exam.data.WordEntity
import com.example.exam.data.WordRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AddWordViewModel @Inject constructor(
    private val wordRepository: WordRepository
) : ViewModel() {

    fun saveWord(word: WordEntity) {
        viewModelScope.launch {
            wordRepository.insertWord(word)
        }
    }
} 