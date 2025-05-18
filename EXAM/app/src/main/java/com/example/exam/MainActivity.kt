package com.example.exam

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import androidx.lifecycle.ViewModelProvider
import com.example.exam.data.WordDatabase
import com.example.exam.data.WordRepository
import com.example.exam.main.MainScreen
import com.example.exam.main.MainViewModel


class MainActivity : ComponentActivity() {
    private lateinit var mainViewModel: MainViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize database and repository
        val database = WordDatabase.getDatabase(applicationContext)
        val repository = WordRepository(database.wordDao())

        // Initialize ViewModel with the factory
        mainViewModel = ViewModelProvider(
            this,
            MainViewModel.Factory(application, repository)
        ).get(MainViewModel::class.java)

        setContent {
            ExamTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    MainScreen(viewModel = mainViewModel)
                }
            }
        }
    }
}
