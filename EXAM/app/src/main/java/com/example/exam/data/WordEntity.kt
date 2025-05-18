package com.example.exam.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.ColumnInfo

@Entity(tableName = "words")
data class WordEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    
    @ColumnInfo(name = "foreign_word")
    val foreignWord: String,
    
    @ColumnInfo(name = "mongolian_word")
    val mongolianWord: String
)
