package com.example.exam.settings

import android.app.Application
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

private val Any.value: Boolean
    get() {
        TODO("Not yet implemented")
    }


@Composable
fun SettingsScreen(viewModel: SettingsViewModel) {
    var languageSwitch by remember { mutableStateOf(true) }
    var foreignWord by remember { mutableStateOf("") }
    var mongolianWord by remember { mutableStateOf("") }

    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = "Тохиргоо", style = MaterialTheme.typography.titleLarge)

        Spacer(modifier = Modifier.height(16.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text("Гадаад үг харуулах")
            Switch(
                checked = languageSwitch,
                onCheckedChange = {
                    languageSwitch = it
                    viewModel.saveLanguageSwitch(it)
                }
            )
            Text("Монгол үг харуулах")
            val showMongolianWord =
                viewModel.showMongolianWord.collectAsState(initial = true)

            Switch(checked = showMongolianWord.value, onCheckedChange = { viewModel.setShowMongolianWord(it) })
        }

        Spacer(modifier = Modifier.height(16.dp))

        TextField(
            value = foreignWord,
            onValueChange = { foreignWord = it },
            label = { Text("Гадаад үг") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(8.dp))

        TextField(
            value = mongolianWord,
            onValueChange = { mongolianWord = it },
            label = { Text("Монгол үг") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                viewModel.saveForeignWord(foreignWord)
                viewModel.saveMongolianWord(mongolianWord)
            }
        ) {
            Text("Тохиргоог хадгалах")
        }
    }
}

private fun Any.collectAsState(initial: Boolean) {

}

@Preview
@Composable
fun SettingsScreenPreview() {
    SettingsScreen(viewModel = SettingsViewModel(Application()))
}
