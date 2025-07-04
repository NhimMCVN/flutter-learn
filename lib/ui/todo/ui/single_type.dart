import 'package:first_flutter_app/ui/todo/ui/category_item.dart';
import 'package:flutter/material.dart';

class SingleType extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function() onChanged;

   const SingleType({
    required this.title,
    required this.onChanged,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isSelected ? Colors.deepPurple : Colors.grey[300] ?? Colors.grey, width: 2),
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          padding: EdgeInsets.all(8),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.deepPurple : Colors.grey[300] ?? Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: (){
          onChanged();
        },
      ),
    );
  }
}
