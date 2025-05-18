package com.example.exam.dataStore

import android.content.Context
import android.os.Parcel
import android.os.Parcelable
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "settings")

class SettingsRepository(private val context: Context) {
    companion object {
        private val FOREIGN_WORD_VISIBLE = booleanPreferencesKey("foreign_word_visible")
        private val MONGOLIAN_WORD_VISIBLE = booleanPreferencesKey("mongolian_word_visible")
    }

    suspend fun setForeignWordVisible(isVisible: Boolean) {
        context.dataStore.edit { it[FOREIGN_WORD_VISIBLE] = isVisible }
    }

    suspend fun setMongolianWordVisible(isVisible: Boolean) {
        context.dataStore.edit { it[MONGOLIAN_WORD_VISIBLE] = isVisible }
    }

    val foreignWordVisible: Flow<Boolean> = context.dataStore.data.map { it[FOREIGN_WORD_VISIBLE] ?: true }
    val mongolianWordVisible: Flow<Boolean> = context.dataStore.data.map { it[MONGOLIAN_WORD_VISIBLE] ?: true }

    fun getForeignWordVisibilitySync(): Boolean = runBlocking { context.dataStore.data.first()[FOREIGN_WORD_VISIBLE] ?: true }
    fun getMongolianWordVisibilitySync(): Boolean = runBlocking { context.dataStore.data.first()[MONGOLIAN_WORD_VISIBLE] ?: true }
}

class SettingsDataStore() : Parcelable {


    val showForeignWord: Any
        get() {
            TODO()
        }
    val showMongolianWord: Any
        get() {
            TODO()
        }

    constructor(parcel: Parcel) : this() {
    }

    fun setShowForeignWord(show: Boolean) {
        TODO("Not yet implemented")

}

    override fun writeToParcel(parcel: Parcel, flags: Int) {

    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<SettingsDataStore> {
        override fun createFromParcel(parcel: Parcel): SettingsDataStore {
            return SettingsDataStore(parcel)
        }

        override fun newArray(size: Int): Array<SettingsDataStore?> {
            return arrayOfNulls(size)
        }
    }

    fun setShowMongolianWord(show: Boolean) {

    }
    }


