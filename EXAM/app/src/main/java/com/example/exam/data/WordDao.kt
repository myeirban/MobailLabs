package com.example.exam.data

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface WordDao {
    @Insert
    fun insertWord(word: WordEntity): Long

    @Update
    fun updateWord(word: WordEntity): Int

    @Delete
    fun deleteWord(word: WordEntity): Int

    @Query("SELECT * FROM words WHERE id = :id")
    fun getWordById(id: Int): Flow<WordEntity>

    @Query("SELECT * FROM words ORDER BY id ASC")
    fun getAllWords(): Flow<List<WordEntity>>
}