package com.example.examlastlast.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "words")
data class Word(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val foreignWord: String,
    val mongolianWord: String
) 