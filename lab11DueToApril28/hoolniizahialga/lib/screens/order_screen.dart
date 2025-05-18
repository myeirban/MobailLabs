import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../models/item.dart';
import '../widgets/menu_item_title.dart';

// OrderScreen нь хэрэглэгчийн захиалгыг харуулна
class OrderScreen extends StatefulWidget {
  final Customer customer;

  const OrderScreen({Key? key, required this.customer}) : super(key: key);

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

// OrderScreen-ийн дотоод төлөвийг хянах хэсэг
class _OrderScreenState extends State<OrderScreen> {
  // Захиалсан хоолнуудыг хадгалах жагсаалт
  late List<Item> orderItems;

  // Анх дэлгэц нээгдэхэд дуудагдана
  @override
  void initState() {
    super.initState();

    // Хэрэглэгчийн захиалсан хоолнуудыг хуулах
    orderItems = List.from(widget.customer.items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Захиалга')),

      // Захиалсан хоолнуудыг харуулах ListView
      body: ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final item = orderItems[index];

          return Dismissible(
            key: Key(item.uid), // давтагдашгүй түлхүүр
            onDismissed: (direction) {
              setState(() {
                orderItems.removeAt(index); // жагсаалтаас устгана
              });
            },
            background: Container(
              color: Colors.red,
            ), // Арын улаан өнгө (устгах үед)
            child: MenuItemTile(
              item: item,
              selected: false, // You can manage selection state if needed
              onChanged: (bool? value) {
                // Handle selection if needed
              },
            ),
          );
        },
      ),

      // Захиалгыг баталгаажуулах товч
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Захиалагч: ${widget.customer.name}'),
            ElevatedButton(
              onPressed: () {
                // Баталгаажуулах үед Snackbar-аар харуулна
                final snackBar = SnackBar(
                  content: Text(
                    'Захиалсан хоол: ${orderItems.map((e) => e.name).join(', ')}',
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Захиалгыг баталгаажуулах'),
            ),
          ],
        ),
      ),
    );
  }
}
