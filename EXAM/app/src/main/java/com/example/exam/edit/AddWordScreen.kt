package com.example.exam.edit

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import com.example.exam.data.WordEntity

@Composable
fun AddWordScreen(
    onNavigateBack: () -> Unit,
    viewModel: AddWordViewModel = ViewModel()
) {
    var foreignWord by remember { mutableStateOf("") }
    var mongolianWord by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        OutlinedTextField(
            value = foreignWord,
            onValueChange = { foreignWord = it },
            label = { Text("Foreign Word") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(
            value = mongolianWord,
            onValueChange = { mongolianWord = it },
            label = { Text("Mongolian Word") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                viewModel.saveWord(
                    WordEntity(
                        foreignWord = foreignWord,
                        mongolianWord = mongolianWord
                    )
                )
                onNavigateBack()
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Save")
        }
    }
}
