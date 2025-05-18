import 'package:flutter/material.dart';
import '../models/item.dart';

// MenuItemTile гэдэг нь нэг хоолны мэдээллийг харуулдаг виджет юм
class MenuItemTile extends StatelessWidget {
  final Item item; // Хоолны мэдээлэл
  final bool selected; // Энэ хоол сонгогдсон эсэх
  final ValueChanged<bool?> onChanged; // Checkbox дарсан үед дуудагдах функц

  const MenuItemTile({
    Key? key,
    required this.item,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Зураг хэсэг
      leading: Image(
        image: item.imageProvider,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),

      // Нэр болон үнэ
      title: Text('${item.name} - ${item.price}₮'),

      // Checkbox (сонгогдсон эсэх)
      trailing: Checkbox(value: selected, onChanged: onChanged),
    );
  }
}
