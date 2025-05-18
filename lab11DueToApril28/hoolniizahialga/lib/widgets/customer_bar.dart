import 'package:flutter/material.dart';
import '../models/customer.dart';

// CustomerBar гэдэг нь хэрэглэгчийн мэдээллийг товчоор харуулдаг виджет юм
class CustomerBar extends StatelessWidget {
  final Customer customer; // Хэрэглэгчийн мэдээлэл
  final VoidCallback onTap; // Дарсан үед дуудагдах функц

  const CustomerBar({Key? key, required this.customer, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Дарсан үед onTap дуудагдана

      child: Container(
        color: Colors.blue, // Цэнхэр background

        padding: EdgeInsets.all(16), // Дотор талын зай

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Гол хэсэгт төвлөрүүлнэ

          children: [
            // Хэрэглэгчийн зураг
            CircleAvatar(backgroundImage: customer.imageProvider),

            SizedBox(width: 12), // Зураг ба текстийн хооронд зай
            // Хэрэглэгчийн нэр ба имэйл
            Text(
              '${customer.name} (${customer.email})',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
