package com.example.exam.edit

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.exam.data.Word

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EditWordScreen(
    word: Word,
    onSaveWord: (Word) -> Unit,
    onBack: () -> Unit
) {
    var foreignWord by remember { mutableStateOf(word.foreignWord) }
    var mongolianWord by remember { mutableStateOf(word.mongolianWord) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Үг засах") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        },
        content = { padding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {

                Text("Гадаад үг")
                BasicTextField(
                    value = foreignWord,
                    onValueChange = { foreignWord = it },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(8.dp),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(16.dp))


                Text("Монгол утга")
                BasicTextField(
                    value = mongolianWord,
                    onValueChange = { mongolianWord = it },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(8.dp),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(16.dp))


                Button(
                    onClick = {
                        if (foreignWord.isNotEmpty() && mongolianWord.isNotEmpty()) {
                            onSaveWord(Word(
                                id = word.id,
                                foreignWord = foreignWord,
                                mongolianWord = mongolianWord,
                                word = TODO()
                            ))
                        }
                    },
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text("Үг хадгалах")
                }
            }
        }
    )
}
