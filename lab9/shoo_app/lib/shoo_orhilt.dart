import 'dart:math';
import 'package:flutter/material.dart';

final randomizer = Random();

class ShooOrhilt extends StatefulWidget {
  const ShooOrhilt({super.key});

  @override
  State<ShooOrhilt> createState() => _ShooOrhiltState();
}

class _ShooOrhiltState extends State<ShooOrhilt> {
  var currentDiceRoll = 1;

  void rollDice() {
    setState(() {
      currentDiceRoll = randomizer.nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/dice-\$currentDiceRoll.png', width: 200),
        const SizedBox(height: 20),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 28),
          ),
          child: const Text('Шоог орхих'),
        ),
      ],
    );
  }
}
