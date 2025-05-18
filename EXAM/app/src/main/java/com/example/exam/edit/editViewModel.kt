package com.example.exam.edit

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.exam.data.Word
import com.example.exam.data.WordRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class EditViewModel @Inject constructor(
    private val wordRepository: WordRepository
) : ViewModel() {

    fun saveWord(word: Word) {
        viewModelScope.launch {
            wordRepository.insertWord(word)
        }
    }
}
