package com.example.examlastlast.ui

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.examlastlast.data.Word
import com.example.examlastlast.data.WordDatabase
import com.example.examlastlast.data.WordRepository
import com.example.examlastlast.data.SettingsRepository
import com.example.examlastlast.ui.theme.ExamLastLastTheme
import kotlinx.coroutines.launch
import androidx.lifecycle.viewmodel.compose.viewModel

@Composable
fun WordEditScreen(
    wordId: Long?,
    viewModel: WordViewModel,
    onBack: () -> Unit
) {
    var foreignWord by remember { mutableStateOf("") }
    var mongolianWord by remember { mutableStateOf("") }

    // If editing existing word, load its data
    LaunchedEffect(wordId) {
        wordId?.let { id ->
            viewModel.getWordToEdit()?.let { word ->
                foreignWord = word.foreignWord
                mongolianWord = word.mongolianWord
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        // Top Bar
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = onBack) {
                Icon(Icons.Default.ArrowBack, contentDescription = "Back")
            }
            Text(
                text = if (wordId == null) "Add New Word" else "Edit Word",
                style = MaterialTheme.typography.headlineMedium
            )
            Spacer(modifier = Modifier.width(48.dp)) // For balance
        }

        Spacer(modifier = Modifier.height(32.dp))

        // Input Fields
        OutlinedTextField(
            value = foreignWord,
            onValueChange = { foreignWord = it },
            label = { Text("Foreign Word") },
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 16.dp)
        )

        OutlinedTextField(
            value = mongolianWord,
            onValueChange = { mongolianWord = it },
            label = { Text("Mongolian Word") },
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 32.dp)
        )

        // Save Button
        Button(
            onClick = {
                if (wordId == null) {
                    viewModel.addWord(foreignWord, mongolianWord)
                } else {
                    viewModel.getWordToEdit()?.let { word ->
                        viewModel.updateWord(word.copy(
                            foreignWord = foreignWord,
                            mongolianWord = mongolianWord
                        ))
                    }
                }
                onBack()
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            enabled = foreignWord.isNotBlank() && mongolianWord.isNotBlank()
        ) {
            Text(if (wordId == null) "Add Word" else "Save Changes")
        }
    }
}

@Preview(name = "Add Word")
@Composable
fun PreviewAddWord() {
    ExamLastLastTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            val context = LocalContext.current
            val wordRepository = WordRepository(WordDatabase.getDatabase(context).wordDao())
            val settingsRepository = SettingsRepository(context)
            WordEditScreen(
                wordId = null,
                viewModel = WordViewModel(wordRepository, settingsRepository),
                onBack = {}
            )
        }
    }
}

@Preview(name = "Edit Word")
@Composable
fun PreviewEditWord() {
    ExamLastLastTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            val context = LocalContext.current
            val wordRepository = WordRepository(WordDatabase.getDatabase(context).wordDao())
            val settingsRepository = SettingsRepository(context)
            WordEditScreen(
                wordId = 1,
                viewModel = WordViewModel(wordRepository, settingsRepository),
                onBack = {}
            )
        }
    }
}

