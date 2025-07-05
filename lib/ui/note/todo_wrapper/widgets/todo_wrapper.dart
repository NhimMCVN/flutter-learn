import 'package:first_flutter_app/ui/settings/widgets/settings.dart';
import 'package:first_flutter_app/ui/note/todo_screen/widgets/create_todo.dart';
import 'package:first_flutter_app/ui/note/todo_screen/widgets/list_todo.dart';
import 'package:first_flutter_app/ui/note/todo_wrapper/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoWrapper extends StatefulWidget {
  const TodoWrapper({super.key});

  @override
  State<TodoWrapper> createState() => _TodoWrapperState();
}

class _TodoWrapperState extends State<TodoWrapper> {
  int _currentIndex = 0;

  void _onNavBarIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  AppBar _buildAppBar() {
    final titles = ["Money lover", "Reports", "Settings"];
    final actions = [
      [
        IconButton(
          onPressed: () {
            print("Press to edit");
          },
          icon: Icon(Icons.edit, color: Colors.white),
        ),
      ],
      [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
    ];
    return AppBar(
      title: Text(
        titles[_currentIndex],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: actions[_currentIndex],
      backgroundColor: Colors.deepPurple,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBarWrapper(
        onIndexChanged: _onNavBarIndexChanged,
        initIndex: _currentIndex,
      ),
      body: [
        CreateTodo(
          onCreated: () {
            setState(() {
              _currentIndex = 1;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tạo thành công!')));
          },
        ),
        ListTodo(),
        Settings(),
      ][_currentIndex],
      appBar: _buildAppBar(),
    );
  }
}
