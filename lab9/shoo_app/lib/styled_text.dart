import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  const StyledText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 28,
        color: Color.fromARGB(200, 255, 255, 255),
      ),
    );
  }
}
