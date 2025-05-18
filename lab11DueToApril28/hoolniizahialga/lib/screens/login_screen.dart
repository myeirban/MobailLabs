import 'package:flutter/material.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  // Нэвтрэх товч дээр дарахад ажиллах функц
  void _login() {
    String name = _controller.text; // бичсэн нэрийг авна

    if (name.isNotEmpty) {
      // хэрвээ нэр хоосон биш бол дараагийн цонх руу шилжинэ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => MenuScreen(
                cashierName: name, // Кассиерийн нэрийг дамжуулна
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nevterch orooroi!'), // Дээд хэсгийн гарчиг
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0), // Эргэн тойронд зай өгнө
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Нэр бичих талбар
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Cashieriin ner cashier', // Тайлбар
                ),
              ),

              SizedBox(height: 20), // Хооронд зай авна
              // Нэвтрэх товч
              ElevatedButton(onPressed: _login, child: Text('Nevtreh')),
            ],
          ),
        ),
      ),
    );
  }
}
