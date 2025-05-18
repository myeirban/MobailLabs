package com.example.examlastlast

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.Manifest
import android.content.pm.PackageManager
import android.content.res.Configuration
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.selection.selectable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.work.*
import com.example.examlastlast.data.AppSettings
import com.example.examlastlast.data.SettingsRepository
import com.example.examlastlast.data.Word
import com.example.examlastlast.data.WordDatabase
import com.example.examlastlast.data.WordRepository
import com.example.examlastlast.ui.*
import com.example.examlastlast.worker.NotificationWorker
import com.example.examlastlast.ui.theme.ExamLastLastTheme
import java.util.concurrent.TimeUnit
import androidx.navigation.NavType
import androidx.navigation.navArgument
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.ui.platform.LocalConfiguration
import com.example.examlastlast.data.DisplayMode
import com.example.examlastlast.worker.DailyNotificationWorker

class VocabularyApp : Application() {
    lateinit var wordRepository: WordRepository
    lateinit var appSettings: AppSettings
    lateinit var settingsRepository: SettingsRepository

    override fun onCreate() {
        super.onCreate()
        try {
            Log.d("VocabularyApp", "Initializing application...")
            wordRepository = WordRepository(WordDatabase.getDatabase(this).wordDao())
            Log.d("VocabularyApp", "WordRepository initialized")
            appSettings = AppSettings(this)
            Log.d("VocabularyApp", "AppSettings initialized")
            settingsRepository = SettingsRepository(this)
            Log.d("VocabularyApp", "SettingsRepository initialized")
            createNotificationChannel()
            scheduleDailyNotification()
            Log.d("VocabularyApp", "Application initialization completed")
        } catch (e: Exception) {
            Log.e("VocabularyApp", "Critical error in onCreate: ${e.message}", e)
        }
    }

    fun createNotificationChannel() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    "vocabulary_reminder",
                    "Vocabulary Reminder",
                    NotificationManager.IMPORTANCE_DEFAULT
                ).apply {
                    description = "Reminds you to practice vocabulary"
                }

                val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.createNotificationChannel(channel)
            }
        } catch (e: Exception) {
            Log.e("VocabularyApp", "Error creating notification channel: ${e.message}")
        }
    }

    fun scheduleDailyNotification() {
        try {
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
                .build()

            val notificationRequest = PeriodicWorkRequestBuilder<NotificationWorker>(
                24, TimeUnit.HOURS
            )
                .setConstraints(constraints)
                .build()

            WorkManager.getInstance(this).enqueueUniquePeriodicWork(
                "vocabulary_reminder",
                ExistingPeriodicWorkPolicy.KEEP,
                notificationRequest
            )
        } catch (e: Exception) {
            Log.e("VocabularyApp", "Error scheduling notification: ${e.message}")
        }
    }
}

class MainActivity : ComponentActivity() {
    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) {
            (application as VocabularyApp).createNotificationChannel()
            (application as VocabularyApp).scheduleDailyNotification()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "onCreate started")
        
        // Check for notification permission
        when {
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED -> {
                (application as VocabularyApp).createNotificationChannel()
                (application as VocabularyApp).scheduleDailyNotification()
            }
            else -> {
                requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        }

        setContent {
            Log.d("MainActivity", "Setting up Compose content")
            ExamLastLastTheme(darkTheme = false) {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val navController = rememberNavController()
                    val wordViewModel = remember {
                        WordViewModel(
                            (application as VocabularyApp).wordRepository,
                            (application as VocabularyApp).settingsRepository
                        )
                    }

                    NavHost(navController = navController, startDestination = "main") {
                        composable("main") {
                            WordDisplayScreen(
                                viewModel = wordViewModel,
                                onNavigateToEdit = { wordId ->
                                    navController.navigate("edit/$wordId")
                                },
                                onNavigateToSettings = {
                                    navController.navigate("settings")
                                }
                            )
                        }
                        composable("edit/{wordId}") { backStackEntry ->
                            val wordId = backStackEntry.arguments?.getString("wordId")?.toLongOrNull()
                            WordEditScreen(
                                wordId = wordId,
                                viewModel = wordViewModel,
                                onBack = {
                                    navController.popBackStack()
                                }
                            )
                        }
                        composable("settings") {
                            SettingsScreen(
                                viewModel = wordViewModel,
                                onBack = {
                                    navController.popBackStack()
                                }
                            )
                        }
                    }
                }
            }
        }
        Log.d("MainActivity", "onCreate completed successfully")
    }
}

@Composable
fun VocabularyAppNavigation() {
    val navController = rememberNavController()
    val context = LocalContext.current
    val app = context.applicationContext as VocabularyApp
    val viewModel: WordViewModel = viewModel(
        factory = ViewModelFactory(
            wordRepository = app.wordRepository,
            settingsRepository = app.settingsRepository
        )
    )
    
    NavHost(navController = navController, startDestination = "main") {
        composable("main") {
            WordDisplayScreen(
                viewModel = viewModel,
                onNavigateToEdit = { wordId -> 
                    Log.d("Navigation", "Navigating to edit screen for word ID: $wordId")
                    if (wordId != null) {
                        navController.navigate("edit/$wordId")
                    } else {
                        navController.navigate("edit")
                    }
                },
                onNavigateToSettings = {
                    Log.d("Navigation", "Navigating to settings screen")
                    navController.navigate("settings")
                }
            )
        }
        composable("edit") {
            WordEditScreen(
                wordId = null,
                viewModel = viewModel,
                onBack = { 
                    Log.d("Navigation", "Navigating back to main screen")
                    navController.popBackStack() 
                }
            )
        }
        composable(
            route = "edit/{wordId}",
            arguments = listOf(navArgument("wordId") { type = NavType.LongType })
        ) { backStackEntry ->
            val wordId = backStackEntry.arguments?.getLong("wordId")
            WordEditScreen(
                wordId = wordId,
                viewModel = viewModel,
                onBack = { 
                    Log.d("Navigation", "Navigating back to main screen")
                    navController.popBackStack() 
                }
            )
        }
        composable("settings") {
            SettingsScreen(
                viewModel = viewModel,
                onBack = { 
                    Log.d("Navigation", "Navigating back to main screen")
                    navController.popBackStack() 
                }
            )
        }
    }
}

@Composable
fun WordDisplayScreen(
    viewModel: WordViewModel,
    onNavigateToEdit: (Long?) -> Unit,
    onNavigateToSettings: () -> Unit
) {
    val words by viewModel.words.collectAsState()
    val currentWordIndex by viewModel.currentWordIndex.collectAsState()
    val displayMode by viewModel.displayMode.collectAsState()
    var showMongolian by remember { mutableStateOf(false) }
    var showDeleteDialog by remember { mutableStateOf(false) }
    val configuration = LocalConfiguration.current

    LaunchedEffect(words) {
        if (words.isNotEmpty()) {
            viewModel.setCurrentWordIndex(0)
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = onNavigateToSettings) {
                Icon(Icons.Default.Settings, contentDescription = "Тохиргоо")
            }
            Text(
                text = "Үгсийн сан",
                style = MaterialTheme.typography.headlineMedium
            )
            IconButton(
                onClick = { onNavigateToEdit(null) },
                enabled = true
            ) {
                Icon(Icons.Default.Add, contentDescription = "Үг нэмэх")
            }
        }

        Spacer(modifier = Modifier.height(32.dp))

        if (words.isEmpty()) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text("Үг байхгүй байна")
            }
        } else {
            if (configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
                Row(
                    modifier = Modifier.fillMaxSize(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Column(
                        modifier = Modifier.weight(1f),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        if (displayMode != DisplayMode.MONGOLIAN_ONLY) {
                            Text(
                                text = words[currentWordIndex].foreignWord,
                                style = MaterialTheme.typography.headlineLarge,
                                modifier = Modifier.pointerInput(Unit) {
                                    detectTapGestures(
                                        onTap = { showMongolian = !showMongolian }
                                    )
                                }
                            )
                        }
                        if (displayMode != DisplayMode.FOREIGN_ONLY && showMongolian) {
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                text = words[currentWordIndex].mongolianWord,
                                style = MaterialTheme.typography.headlineMedium
                            )
                        }
                    }
                    Column(
                        modifier = Modifier.weight(1f),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceEvenly
                        ) {
                            IconButton(
                                onClick = { viewModel.moveToPreviousWord() },
                                enabled = currentWordIndex > 0
                            ) {
                                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Өмнөх")
                            }
                            IconButton(
                                onClick = { onNavigateToEdit(words[currentWordIndex].id) }
                            ) {
                                Icon(Icons.Default.Edit, contentDescription = "Засах")
                            }
                            IconButton(
                                onClick = { showDeleteDialog = true }
                            ) {
                                Icon(Icons.Default.Delete, contentDescription = "Устгах")
                            }
                            IconButton(
                                onClick = { viewModel.moveToNextWord() },
                                enabled = currentWordIndex < words.size - 1
                            ) {
                                Icon(Icons.AutoMirrored.Filled.ArrowForward, contentDescription = "Дараах")
                            }
                        }
                    }
                }
            } else {
                Column(
                    modifier = Modifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    if (displayMode != DisplayMode.MONGOLIAN_ONLY) {
                        Text(
                            text = words[currentWordIndex].foreignWord,
                            style = MaterialTheme.typography.headlineLarge,
                            modifier = Modifier.pointerInput(Unit) {
                                detectTapGestures(
                                    onTap = { showMongolian = !showMongolian }
                                )
                            }
                        )
                    }
                    if (displayMode != DisplayMode.FOREIGN_ONLY && showMongolian) {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = words[currentWordIndex].mongolianWord,
                            style = MaterialTheme.typography.headlineMedium
                        )
                    }

                    Spacer(modifier = Modifier.height(32.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceEvenly
                    ) {
                        IconButton(
                            onClick = { viewModel.moveToPreviousWord() },
                            enabled = currentWordIndex > 0
                        ) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Өмнөх")
                        }
                        IconButton(
                            onClick = { onNavigateToEdit(words[currentWordIndex].id) }
                        ) {
                            Icon(Icons.Default.Edit, contentDescription = "Засах")
                        }
                        IconButton(
                            onClick = { showDeleteDialog = true }
                        ) {
                            Icon(Icons.Default.Delete, contentDescription = "Устгах")
                        }
                        IconButton(
                            onClick = { viewModel.moveToNextWord() },
                            enabled = currentWordIndex < words.size - 1
                        ) {
                            Icon(Icons.AutoMirrored.Filled.ArrowForward, contentDescription = "Дараах")
                        }
                    }
                }
            }
        }
    }

    if (showDeleteDialog) {
        AlertDialog(
            onDismissRequest = { showDeleteDialog = false },
            title = { Text("Үг устгах") },
            text = { Text("Та энэ үгийг устгахдаа итгэлтэй байна уу?") },
            confirmButton = {
                TextButton(
                    onClick = {
                        viewModel.deleteWord(words[currentWordIndex])
                        showDeleteDialog = false
                    }
                ) {
                    Text("Тийм")
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteDialog = false }) {
                    Text("Үгүй")
                }
            }
        )
    }
}

@Composable
fun WordEditScreen(
    wordId: Long?,
    viewModel: WordViewModel,
    onBack: () -> Unit
) {
    var foreignWord by remember { mutableStateOf("") }
    var mongolianWord by remember { mutableStateOf("") }

    LaunchedEffect(wordId) {
        if (wordId != null) {
            viewModel.getWordById(wordId)?.let { word ->
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
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = onBack) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Буцах")
            }
            Text(
                text = if (wordId != null) "Үг засах" else "Шинэ үг нэмэх",
                style = MaterialTheme.typography.headlineMedium
            )
            Box(modifier = Modifier.width(48.dp))
        }

        Spacer(modifier = Modifier.height(32.dp))

        OutlinedTextField(
            value = foreignWord,
            onValueChange = { foreignWord = it },
            label = { Text("Гадаад үг") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(
            value = mongolianWord,
            onValueChange = { mongolianWord = it },
            label = { Text("Монгол үг") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(32.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            Button(
                onClick = {
                    if (foreignWord.isNotBlank() && mongolianWord.isNotBlank()) {
                        if (wordId != null) {
                            viewModel.updateWord(Word(id = wordId, foreignWord = foreignWord, mongolianWord = mongolianWord))
                        } else {
                            viewModel.addWord(Word(id = 0, foreignWord = foreignWord, mongolianWord = mongolianWord))
                        }
                        onBack()
                    }
                },
                enabled = foreignWord.isNotBlank() && mongolianWord.isNotBlank()
            ) {
                Text("ХАДГАЛАХ")
            }
            Button(
                onClick = onBack,
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.secondary)
            ) {
                Text("БОЛИХ")
            }
        }
    }
}

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
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = onBack) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Буцах")
            }
            Text(
                text = "Тохиргоо",
                style = MaterialTheme.typography.headlineMedium
            )
            Box(modifier = Modifier.width(48.dp))
        }

        Spacer(modifier = Modifier.height(32.dp))

        Text(
            text = "Харуулах горим:",
            style = MaterialTheme.typography.titleLarge,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        Column(
            modifier = Modifier.selectableGroup()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .selectable(
                        selected = displayMode == DisplayMode.BOTH,
                        onClick = { viewModel.setDisplayMode(0) },
                        role = Role.RadioButton
                    )
                    .padding(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                RadioButton(
                    selected = displayMode == DisplayMode.BOTH,
                    onClick = null
                )
                Text(
                    text = "Бүх үгийг харуулах",
                    modifier = Modifier.padding(start = 16.dp)
                )
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .selectable(
                        selected = displayMode == DisplayMode.FOREIGN_ONLY,
                        onClick = { viewModel.setDisplayMode(1) },
                        role = Role.RadioButton
                    )
                    .padding(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                RadioButton(
                    selected = displayMode == DisplayMode.FOREIGN_ONLY,
                    onClick = null
                )
                Text(
                    text = "Зөвхөн гадаад үг",
                    modifier = Modifier.padding(start = 16.dp)
                )
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .selectable(
                        selected = displayMode == DisplayMode.MONGOLIAN_ONLY,
                        onClick = { viewModel.setDisplayMode(2) },
                        role = Role.RadioButton
                    )
                    .padding(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                RadioButton(
                    selected = displayMode == DisplayMode.MONGOLIAN_ONLY,
                    onClick = null
                )
                Text(
                    text = "Зөвхөн монгол үг",
                    modifier = Modifier.padding(start = 16.dp)
                )
            }
        }
    }
}