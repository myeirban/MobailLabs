package com.example.exam.dataStore

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "settings")

class Reposity(private val context: Context) {

    companion object {
        val FOREIGN_WORD_VISIBLE = booleanPreferencesKey("foreign_word_visible")
        val MONGOLIAN_WORD_VISIBLE = booleanPreferencesKey("mongolian_word_visible")
    }


    suspend fun setForeignWordVisible(isVisible: Boolean) {
        context.dataStore.edit { preferences ->
            preferences[FOREIGN_WORD_VISIBLE] = isVisible
        }
    }


    suspend fun setMongolianWordVisible(isVisible: Boolean) {
        context.dataStore.edit { preferences ->
            preferences[MONGOLIAN_WORD_VISIBLE] = isVisible
        }
    }


    val foreignWordVisible: Flow<Boolean> = context.dataStore.data
        .map { preferences ->
            preferences[FOREIGN_WORD_VISIBLE] ?: true
        }


    val mongolianWordVisible: Flow<Boolean> = context.dataStore.data
        .map { preferences ->
            preferences[MONGOLIAN_WORD_VISIBLE] ?: true
        }


    fun getForeignWordVisibilitySync(): Boolean {
        return runBlocking {
            context.dataStore.data.first()[FOREIGN_WORD_VISIBLE] ?: true
        }
    }

    fun getMongolianWordVisibilitySync(): Boolean {
        return runBlocking {
            context.dataStore.data.first()[MONGOLIAN_WORD_VISIBLE] ?: true
        }
    }
}
