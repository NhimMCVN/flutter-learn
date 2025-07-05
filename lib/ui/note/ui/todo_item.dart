import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:first_flutter_app/ui/note/ui/category_item.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final CategoryUI category;
  final String amount;
  final String description;

  const TodoItem({
    Key? key,
    required this.category,
    required this.amount,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300] ?? Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(category.icon),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.name),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          Spacer(),
          Text(amount),
        ],
      ),
    );
  }
}
