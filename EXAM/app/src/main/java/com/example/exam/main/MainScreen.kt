package com.example.exam.main

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.exam.data.WordEntity

@Composable
fun MainScreen(
    viewModel: MainViewModel
) {
    val words by viewModel.words.collectAsState()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Button(
            onClick = {
                viewModel.addWord(
                    WordEntity(
                        foreignWord = "Hello",
                        mongolianWord = "Сайн уу"
                    )
                )
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Үг нэмэх")
        }

        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn(
            modifier = Modifier.weight(1f)
        ) {
            items(words) { word ->
                WordItem(
                    word = word,
                    onDelete = { viewModel.deleteWord(word) }
                )
            }
        }
    }
}

@Composable
fun WordItem(
    word: WordEntity,
    onDelete: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(text = word.foreignWord)
                Text(text = word.mongolianWord)
            }
            IconButton(onClick = onDelete) {
                Icon(Icons.Default.Delete, contentDescription = "Delete")
            }
        }
    }
}
