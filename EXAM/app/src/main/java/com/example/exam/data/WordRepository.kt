package com.example.exam.data

import android.content.Context
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.Dispatchers

class WordRepository(context: Context) {
    private val wordDao: WordDao = WordDatabase.getDatabase(context).wordDao()

    fun getAllWords(): Flow<List<WordEntity>> = wordDao.getAllWords()

    suspend fun insertWord(word: WordEntity) {
        wordDao.insertWord(word)
    }

    suspend fun updateWord(word: WordEntity) {
        wordDao.updateWord(word)
    }

    suspend fun deleteWord(word: WordEntity) {
        wordDao.deleteWord(word)
    }

    fun getWordById(id: Int): Flow<WordEntity> = wordDao.getWordById(id)
}
