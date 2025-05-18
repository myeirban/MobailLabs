import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row and Stack Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ 1. Row with 3 evenly spaced buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('One')),
                ElevatedButton(onPressed: () {}, child: const Text('Two')),
                ElevatedButton(onPressed: () {}, child: const Text('Three')),
              ],
            ),

            const SizedBox(height: 40),

            // ✅ 2. Stack with text overlaying image
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://picsum.photos/300/200',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const Text(
                  'Overlay Text',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
