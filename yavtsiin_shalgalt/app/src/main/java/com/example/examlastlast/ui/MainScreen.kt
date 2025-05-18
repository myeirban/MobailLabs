package com.example.examlastlast.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewParameter
import androidx.compose.ui.tooling.preview.PreviewParameterProvider
import androidx.compose.ui.unit.dp
import com.example.examlastlast.data.DisplayMode
import com.example.examlastlast.data.Word
import com.example.examlastlast.ui.theme.ExamLastLastTheme
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.unit.DpOffset
import androidx.compose.foundation.clickable
import androidx.compose.ui.platform.LocalConfiguration

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WordDisplayScreen(
    viewModel: WordViewModel,
    onNavigateToEdit: (Long?) -> Unit,
    onNavigateToSettings: () -> Unit
) {
    val words by viewModel.words.collectAsState(initial = emptyList())
    val currentWord by viewModel.currentWord.collectAsState()
    val displayMode by viewModel.displayMode.collectAsState()
    val showMongolian by viewModel.showMongolian.collectAsState()
    
    var showDeleteDialog by remember { mutableStateOf(false) }
    
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
            IconButton(onClick = onNavigateToSettings) {
                Icon(Icons.Default.Settings, contentDescription = "Settings")
            }
            IconButton(
                onClick = { onNavigateToEdit(null) },
                enabled = true // Always enabled as per requirement
            ) {
                Icon(Icons.Default.Add, contentDescription = "Add Word")
            }
        }

        // Word Display
        if (words.isEmpty()) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text("No words in dictionary")
            }
        } else {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                // Foreign Word
                if (displayMode != DisplayMode.MONGOLIAN_ONLY) {
                    Text(
                        text = currentWord?.foreignWord ?: "",
                        style = MaterialTheme.typography.headlineMedium,
                        modifier = Modifier
                            .pointerInput(Unit) {
                                detectTapGestures(
                                    onLongPress = {
                                        currentWord?.let { word ->
                                            viewModel.setWordToEdit(word)
                                            onNavigateToEdit(word.id)
                                        }
                                    }
                                )
                            }
                    )
                }

                // Mongolian Word
                if (displayMode != DisplayMode.FOREIGN_ONLY) {
                    Text(
                        text = if (showMongolian) currentWord?.mongolianWord ?: "" else "???",
                        style = MaterialTheme.typography.headlineMedium,
                        modifier = Modifier
                            .padding(top = 16.dp)
                            .pointerInput(Unit) {
                                detectTapGestures(
                                    onPress = {
                                        viewModel.toggleMongolianVisibility()
                                    },
                                    onLongPress = {
                                        currentWord?.let { word ->
                                            viewModel.setWordToEdit(word)
                                            onNavigateToEdit(word.id)
                                        }
                                    }
                                )
                            }
                    )
                }

                // Navigation Buttons
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 32.dp),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    IconButton(
                        onClick = { viewModel.previousWord() },
                        enabled = words.isNotEmpty()
                    ) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Previous")
                    }
                    
                    IconButton(
                        onClick = { showDeleteDialog = true },
                        enabled = words.isNotEmpty()
                    ) {
                        Icon(Icons.Default.Delete, "Delete")
                    }
                    
                    IconButton(
                        onClick = { viewModel.nextWord() },
                        enabled = words.isNotEmpty()
                    ) {
                        Icon(Icons.AutoMirrored.Filled.ArrowForward, "Next")
                    }
                }
            }
        }
    }

    if (showDeleteDialog) {
        AlertDialog(
            onDismissRequest = { showDeleteDialog = false },
            title = { Text("Delete Word") },
            text = { Text("Are you sure you want to delete this word?") },
            confirmButton = {
                TextButton(
                    onClick = {
                        currentWord?.let { viewModel.deleteWord(it) }
                        showDeleteDialog = false
                    }
                ) {
                    Text("Delete")
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }
}

@Composable
fun WordItem(
    word: Word,
    onEdit: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        onClick = onEdit
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = word.mongolianWord,
                style = MaterialTheme.typography.bodyLarge
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = word.foreignWord,
                style = MaterialTheme.typography.bodyMedium
            )
        }
    }
}

data class PreviewData(
    val words: List<Word>,
    val currentWordIndex: Int,
    val isMongolianVisible: Boolean,
    val isForeignVisible: Boolean
)

class EmptyPreviewDataProvider : PreviewParameterProvider<PreviewData> {
    override val values: Sequence<PreviewData> = sequenceOf(
        PreviewData(
            words = emptyList(),
            currentWordIndex = 0,
            isMongolianVisible = true,
            isForeignVisible = true
        )
    )
}

class PopulatedPreviewDataProvider : PreviewParameterProvider<PreviewData> {
    override val values: Sequence<PreviewData> = sequenceOf(
        PreviewData(
            words = listOf(
                Word(1, "Hello", "Сайн байна уу"),
                Word(2, "Goodbye", "Баяртай"),
                Word(3, "Thank you", "Баярлалаа")
            ),
            currentWordIndex = 0,
            isMongolianVisible = true,
            isForeignVisible = true
        )
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun PreviewMainScreenContent(
    previewData: PreviewData,
    onAddWord: () -> Unit = {},
    onEditWord: (Word) -> Unit = {},
    onSettings: () -> Unit = {}
) {
    val words = remember { previewData.words }
    val currentWordIndex = remember { previewData.currentWordIndex }
    val isMongolianVisible = remember { previewData.isMongolianVisible }
    val isForeignVisible = remember { previewData.isForeignVisible }

    val currentWord = words.getOrNull(currentWordIndex)

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Vocabulary Practice") },
                actions = {
                    IconButton(onClick = onSettings) {
                        Icon(Icons.Default.Settings, contentDescription = "Settings")
                    }
                }
            )
        },
        floatingActionButton = {
            FloatingActionButton(onClick = onAddWord) {
                Icon(Icons.Default.Add, contentDescription = "Add Word")
            }
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            if (words.isEmpty()) {
                Text(
                    text = "No words added yet. Click the + button to add words.",
                    textAlign = TextAlign.Center
                )
            } else {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(16.dp),
                    onClick = { /* Preview only */ }
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        if (isForeignVisible) {
                            Text(
                                text = currentWord?.foreignWord ?: "",
                                style = MaterialTheme.typography.headlineMedium
                            )
                        }
                        Spacer(modifier = Modifier.height(16.dp))
                        if (isMongolianVisible) {
                            Text(
                                text = currentWord?.mongolianWord ?: "",
                                style = MaterialTheme.typography.headlineMedium
                            )
                        }
                    }
                }

                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    IconButton(
                        onClick = { /* Preview only */ },
                        enabled = currentWordIndex > 0
                    ) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Previous")
                    }

                    IconButton(
                        onClick = { currentWord?.let { onEditWord(it) } },
                        enabled = currentWord != null
                    ) {
                        Icon(Icons.Default.Edit, contentDescription = "Edit")
                    }

                    IconButton(
                        onClick = { /* Preview only */ },
                        enabled = currentWordIndex < words.size - 1
                    ) {
                        Icon(Icons.Default.ArrowForward, contentDescription = "Next")
                    }
                }
            }
        }
    }
}

@Preview(name = "Empty State")
@Composable
fun PreviewMainScreenEmpty(
    @PreviewParameter(EmptyPreviewDataProvider::class) previewData: PreviewData
) {
    ExamLastLastTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            PreviewMainScreenContent(previewData = previewData)
        }
    }
}

@Preview(name = "With Words")
@Composable
fun PreviewMainScreenWithWords(
    @PreviewParameter(PopulatedPreviewDataProvider::class) previewData: PreviewData
) {
    ExamLastLastTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            PreviewMainScreenContent(previewData = previewData)
        }
    }
} 