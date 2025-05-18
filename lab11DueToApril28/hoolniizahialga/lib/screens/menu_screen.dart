import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/customer.dart';
import '../widgets/menu_item_title.dart';

class MenuItemTile extends StatelessWidget {
  final Item item;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  const MenuItemTile({
    Key? key,
    required this.item,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(
        image: item.imageProvider,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text('${item.name} - ${item.price}₮'),
      trailing: Checkbox(value: selected, onChanged: onChanged),
    );
  }
}

// MenuScreen нь StatefulWidget
class MenuScreen extends StatefulWidget {
  final String cashierName;

  const MenuScreen({Key? key, required this.cashierName}) : super(key: key);

  @override
  State<MenuScreen> createState() {
    return _MenuScreenState();
  }
}

// MenuScreen-ийн үндсэн логик энд байна
class _MenuScreenState extends State<MenuScreen> {
  // Хоолны цэсийн жагсаалт
  final List<Item> menuItems = [
    Item(
      name: 'Бууз',
      price: 5000,
      uid: '1',
      imageProvider: NetworkImage(
        'https://cdn.pixabay.com/photo/2016/03/05/19/02/noodles-1238246_1280.jpg',
      ),
    ),
    Item(
      name: 'Цуйван',
      price: 6000,
      uid: '2',
      imageProvider: NetworkImage(
        'https://cdn.pixabay.com/photo/2016/03/05/19/02/noodles-1238246_1280.jpg',
      ),
    ),
    Item(
      name: 'Гуляш',
      price: 7000,
      uid: '3',
      imageProvider: NetworkImage(
        'https://cdn.pixabay.com/photo/2016/03/05/19/02/noodles-1238246_1280.jpg',
      ),
    ),
    Item(
      name: 'Хуушуур',
      price: 4000,
      uid: '4',
      imageProvider: NetworkImage(
        'https://cdn.pixabay.com/photo/2016/03/05/19/02/noodles-1238246_1280.jpg',
      ),
    ),
    Item(
      name: 'Шөл',
      price: 3500,
      uid: '5',
      imageProvider: NetworkImage(
        'https://cdn.pixabay.com/photo/2016/03/05/19/02/soup-1238246_1280.jpg',
      ),
    ),
    Item(
      name: 'Тахианы мах',
      price: 8000,
      uid: '6',
      imageProvider: NetworkImage(
        'https://cdn.pixabay.com/photo/2016/03/05/19/02/noodles-1238246_1280.jpg',
      ),
    ),
    Item(
      name: 'Өндөгтэй хуурга',
      price: 4500,
      uid: '7',
      imageProvider: NetworkImage(
        'https://cdn.pixabay.com/photo/2016/03/05/19/02/noodles-1238246_1280.jpg',
      ),
    ),
  ];

  // Захиалагчийн мэдээлэл
  final Customer customer = Customer(
    name: 'Захиалагч',
    email: 'customer@example.com',
    imageProvider: NetworkImage(
      'https://randomuser.me/api/portraits/men/1.jpg',
    ),
  );

  // Сагс руу хоол нэмэх үед дуудагдана
  void _addItemToCart(Item item) {
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Хоолны цэс')),
      body: Column(
        children: [
          // Хоолны жагсаалт (татаж болдог)
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                Item item = menuItems[index];

                return Draggable<Item>(
                  data: item, // Сагс руу чирэхэд дамжуулах хоол
                  feedback: Material(
                    child: Image(
                      image: item.imageProvider,
                      width: 80,
                      height: 80,
                    ),
                  ),
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
          ),

          // Захиалгын сагс (сүүлд хоол нэмэгдэх хэсэг)
          DragTarget<Item>(
            onAccept: (item) {
              _addItemToCart(item); // Сагс руу нэмнэ
            },
            builder: (context, candidateItems, rejectedItems) {
              return Container(
                height: 120,
                width: double.infinity,
                color:
                    candidateItems.isNotEmpty
                        ? Colors.green[100]
                        : Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Захиалгын сагс'),
                    Text('Нийт хоол: ${customer.items.length}'),
                    Text('Нийт үнэ: ${customer.formattedTotalItemPrice}'),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to OrderScreen to confirm the order
                        Navigator.pushNamed(
                          context,
                          '/order',
                          arguments: customer,
                        );
                      },
                      child: Text('Захиалгыг баталгаажуулах'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
