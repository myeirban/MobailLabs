package com.example.examlastlast.ui

import android.content.Context
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewParameter
import androidx.compose.ui.tooling.preview.PreviewParameterProvider
import androidx.compose.ui.unit.dp
import com.example.examlastlast.data.AppSettings
import com.example.examlastlast.data.DisplayMode
import com.example.examlastlast.ui.theme.ExamLastLastTheme
import kotlinx.coroutines.launch
import androidx.lifecycle.viewmodel.compose.viewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    viewModel: WordViewModel,
    onBack: () -> Unit
) {
    val displayMode by viewModel.displayMode.collectAsState()

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
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
            }
            Text(
                text = "Settings",
                style = MaterialTheme.typography.headlineMedium
            )
            Spacer(modifier = Modifier.width(48.dp)) // For balance
        }

        Spacer(modifier = Modifier.height(32.dp))

        // Display Mode Settings
        Text(
            text = "Display Mode",
            style = MaterialTheme.typography.titleLarge,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        Column {
            RadioButton(
                selected = displayMode == DisplayMode.BOTH,
                onClick = { viewModel.setDisplayMode(DisplayMode.BOTH) }
            ) {
                Text("Show Both Words")
            }

            RadioButton(
                selected = displayMode == DisplayMode.FOREIGN_ONLY,
                onClick = { viewModel.setDisplayMode(DisplayMode.FOREIGN_ONLY) }
            ) {
                Text("Show Foreign Word Only")
            }

            RadioButton(
                selected = displayMode == DisplayMode.MONGOLIAN_ONLY,
                onClick = { viewModel.setDisplayMode(DisplayMode.MONGOLIAN_ONLY) }
            ) {
                Text("Show Mongolian Word Only")
            }
        }
    }
}

@Preview(name = "Settings Screen")
@Composable
fun PreviewSettingsScreen() {
    val context = LocalContext.current
    ExamLastLastTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            SettingsScreen(
                viewModel = WordViewModel(context),
                onBack = {}
            )
        }
    }
} 