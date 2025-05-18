// Flutter san oruulah
import 'package:flutter/material.dart';

void main() {
  runApp(const MiniiApp());
}

class MiniiApp extends StatelessWidget {
  const MiniiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minii ehnii app',
      home: ToolagchPage(),
    );
  }
}

class ToolagchPage extends StatefulWidget {
  @override
  State<ToolagchPage> createState() {
    return _ToolagchPageState();
  }
}

class _ToolagchPageState extends State<ToolagchPage> {
  int miniiToo = 0;

  void nemeye() {
    setState(() {
      miniiToo = miniiToo + 1;
    });
  }

  void hasya() {
    setState(() {
      miniiToo = miniiToo - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('the counter app'),
        backgroundColor: Colors.orange,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 3),
              ),

              padding: EdgeInsets.all(20),

              child: Text(
                '$miniiToo',
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: hasya,

                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.remove, color: Colors.white, size: 60),
                    ),
                  ),
                ),

                SizedBox(width: 80),

                GestureDetector(
                  onTap: nemeye,

                  child: Container(
                    width: 100,
                    height: 100,

                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Center(
                      child: Icon(Icons.add, color: Colors.white, size: 60),
                    ),
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
