import 'package:flutter/material.dart';

//app bar shaardlagagui tul ashiglaagui.
void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: CalculatorScreen(),
    );
  }
}

//hereglegchiin oruulsan too ,uildel, bolon ur dung hadgalah ,oorchloh shar
//tai uchraas .input ,result operator , num1,2 geh met huvsagchid State -d
//hadgalagdaj bn
class CalculatorScreen extends StatefulWidget {
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '0';

  String result = '0';

  String operator = '';

  double num1 = 0;

  double num2 = 0;

  bool shouldResetInput = false;
  //button pressed ni hereglegchiin darsan tovchni utgiig avch ,tuunii daguu
  //undsen uildlee hiideg logic funkts
  //too nemeh logic bii
  //input ni hereglegchiin yag odoogoor oruulj bui utga
  void buttonPressed(String value) {
    setState(() {
      //widget iin state iig shinecleh bolomj
      //jishee ni UI oorchlolt oruulahiin tuld setState() iig duudsan.
      if (value == 'C') {
        input = '0';

        result = '0';

        operator = '';

        num1 = 0;

        num2 = 0;

        shouldResetInput = false;
      } else if (value == 'DEL') {
        if (input.length > 1) {
          input = input.substring(0, input.length - 1);
        } else {
          input = '0';
        }
      } else if (value == '+' ||
          value == '-' ||
          value == 'x' ||
          value == '/' ||
          value == '%') {
        operator = value;

        num1 = double.tryParse(input) ?? 0;

        shouldResetInput = true;
      } else if (value == '=') {
        num2 = double.tryParse(input) ?? 0;

        double res = 0;

        switch (operator) {
          case '+':
            res = num1 + num2;

            break;

          case '-':
            res = num1 - num2;

            break;

          case 'x':
            res = num1 * num2;

            break;

          case '/':
            res = num2 != 0 ? num1 / num2 : 0;

            break;

          case '%':
            res = num1 % num2;

            break;
        }

        result = res.toString().replaceAll(RegExp(r"\.0+$"), "");

        input = result;

        operator = '';

        shouldResetInput = true;
      } else {
        if (shouldResetInput) {
          input = '';

          shouldResetInput = false;
        }

        if (value == '.' && input.contains('.')) return;

        if (input == '0' && value != '.') {
          input = value;
        } else {
          input += value;
        }
      }
    });
  }

  Widget buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      //tovchloruudiig ijil haragduulahiin tuld ashiglasan
      child: Padding(
        padding: const EdgeInsets.all(4.0),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],

            foregroundColor: textColor ?? Colors.black,

            padding: const EdgeInsets.symmetric(vertical: 22),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          onPressed: () => buttonPressed(text),

          child: Text(
            text,

            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            Container(
              alignment: Alignment.centerRight,

              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Text(
                input,

                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                buildButton('C', color: Colors.black, textColor: Colors.white),

                buildButton('%', color: Colors.black, textColor: Colors.white),

                buildButton(
                  'DEL',
                  color: Colors.black,
                  textColor: Colors.white,
                ),

                buildButton('/', color: Colors.black, textColor: Colors.white),
              ],
            ),

            Row(
              children: [
                buildButton('7'),

                buildButton('8'),

                buildButton('9'),

                buildButton('x', color: Colors.black, textColor: Colors.white),
              ],
            ),

            Row(
              children: [
                buildButton('4'),

                buildButton('5'),

                buildButton('6'),

                buildButton('-', color: Colors.black, textColor: Colors.white),
              ],
            ),

            Row(
              children: [
                buildButton('1'),

                buildButton('2'),

                buildButton('3'),

                buildButton('+', color: Colors.black, textColor: Colors.white),
              ],
            ),

            Row(
              children: [
                buildButton('00'),

                buildButton('0'),

                buildButton('.'),

                buildButton('=', color: Colors.black, textColor: Colors.white),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
