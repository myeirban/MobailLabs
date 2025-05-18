package com.example.examlastlast.data

import kotlinx.coroutines.flow.Flow

class WordRepository(private val wordDao: WordDao) {
    fun getAllWords() = wordDao.getAllWords()

    suspend fun insertWord(word: Word) = wordDao.insertWord(word)

    suspend fun updateWord(word: Word) = wordDao.updateWord(word)

    suspend fun deleteWord(word: Word) = wordDao.deleteWord(word)

    suspend fun getWordById(id: Long): Word? {
        return wordDao.getWordById(id)
    }
} 