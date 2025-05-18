package com.example.examlastlast.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.examlastlast.data.*
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class WordViewModel(
    private val wordRepository: WordRepository,
    private val settingsRepository: SettingsRepository
) : ViewModel() {
    private val _words = MutableStateFlow<List<Word>>(emptyList())
    val words: StateFlow<List<Word>> = _words.asStateFlow()

    private val _currentWordIndex = MutableStateFlow(0)
    val currentWordIndex: StateFlow<Int> = _currentWordIndex.asStateFlow()
    
    private val _showMongolian = MutableStateFlow(false)
    val showMongolian: StateFlow<Boolean> = _showMongolian.asStateFlow()

    val currentWord: StateFlow<Word?> = combine(_words, _currentWordIndex) { words, index ->
        words.getOrNull(index)
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(), null)

    val displayMode: StateFlow<DisplayMode> = settingsRepository.displayMode
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(), DisplayMode.BOTH)

    private var wordToEdit: Word? = null

    init {
        viewModelScope.launch {
            wordRepository.getAllWords().collect { wordList ->
                _words.value = wordList
                if (wordList.isNotEmpty() && _currentWordIndex.value >= wordList.size) {
                    _currentWordIndex.value = 0
                }
            }
        }
    }

    fun setCurrentWordIndex(index: Int) {
        if (index >= 0 && index < _words.value.size) {
            _currentWordIndex.value = index
        }
    }

    fun moveToNextWord() {
        if (_words.value.isNotEmpty()) {
            _currentWordIndex.value = (_currentWordIndex.value + 1) % _words.value.size
            _showMongolian.value = false
        }
    }

    fun moveToPreviousWord() {
        if (_words.value.isNotEmpty()) {
            _currentWordIndex.value = (_currentWordIndex.value - 1 + _words.value.size) % _words.value.size
            _showMongolian.value = false
        }
    }

    fun nextWord() {
        moveToNextWord()
    }

    fun previousWord() {
        moveToPreviousWord()
    }

    fun toggleMongolianVisibility() {
        _showMongolian.value = !_showMongolian.value
    }

    fun setWordToEdit(word: Word) {
        wordToEdit = word
    }

    fun getWordToEdit(): Word? = wordToEdit

    fun getWordById(id: Long): Word? {
        return _words.value.find { it.id == id }
    }

    fun addWord(foreignWord: String, mongolianWord: String) {
        viewModelScope.launch {
            wordRepository.insertWord(Word(0, foreignWord, mongolianWord))
        }
    }

    fun addWord(word: Word) {
        viewModelScope.launch {
            wordRepository.insertWord(word)
        }
    }

    fun updateWord(word: Word) {
        viewModelScope.launch {
            wordRepository.updateWord(word)
        }
    }

    fun deleteWord(word: Word) {
        viewModelScope.launch {
            wordRepository.deleteWord(word)
            if (_words.value.isEmpty()) {
                _currentWordIndex.value = 0
            }
        }
    }

    fun setDisplayMode(mode: DisplayMode) {
        viewModelScope.launch {
            settingsRepository.setDisplayMode(mode)
        }
    }
}

enum class DisplayMode {
    BOTH,
    FOREIGN_ONLY,
    MONGOLIAN_ONLY
} 