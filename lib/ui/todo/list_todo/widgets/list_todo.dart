import 'package:first_flutter_app/ui/todo/list_todo/widgets/todo_item.dart';
import 'package:first_flutter_app/ui/todo/ui/category_item.dart';
import 'package:flutter/material.dart';

class ListTodo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListTodoState();
}

class _ListTodoState extends State<ListTodo> {
  final List<Map<String, dynamic>> todos = [
    {
      'category': Category("Cosmetic", Icons.face),
      'amount': "120,100",
      'description': "Test",
    },
    {
      'category': Category("Food", Icons.fastfood),
      'amount': "50,000",
      'description': "Lunch",
    },
    {
      'category': Category("Transport", Icons.directions_car),
      'amount': "30,000",
      'description': "Taxi",
    },
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        SizedBox(height: 12),
        ...todos.map((todo) => Column(
          children: [
            TodoItem(
              category: todo['category'],
              amount: todo['amount'],
              description: todo['description'],
            ), 
            SizedBox(height: 12,),
          ],
        )).toList(),
      ],
    );
  }
}
