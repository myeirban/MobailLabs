import 'package:flutter/material.dart';

void main() {
  runApp(const PuppyApp());
}

class PuppyApp extends StatelessWidget {
  const PuppyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puppy Size App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PuppyResizePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PuppyResizePage extends StatefulWidget {
  const PuppyResizePage({super.key});

  @override
  State<PuppyResizePage> createState() => _PuppyResizePageState();
}

class _PuppyResizePageState extends State<PuppyResizePage> {
  // Initial size of the puppy image
  double _puppySize = 100;

  // Function to double the size of the puppy image
  void _increasePuppySize() {
    setState(() {
      _puppySize *= 2; // Double the size
    });
  }

  // Function to reset the size of the puppy image
  void _resetPuppySize() {
    setState(() {
      _puppySize = 100; // Reset to initial size
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puppy Size App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Puppy image with dynamic size
            Container(
              width: _puppySize,
              height: _puppySize,
              child: Image.network(
                'https://placedog.net/500/500', // Placeholder dog image
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback in case the image cannot be loaded
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.pets, size: 50),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Current size indicator
            Text(
              'Current size: ${_puppySize.toInt()}px',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Button to increase the size
            ElevatedButton(
              onPressed: _increasePuppySize,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Double Puppy Size!',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 15),

            // Button to reset the size
            TextButton(
              onPressed: _resetPuppySize,
              child: const Text('Reset Size', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
