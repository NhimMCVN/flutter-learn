import 'package:first_flutter_app/ui/note/note_screen/widgets/create_note.dart';
import 'package:first_flutter_app/ui/note/note_screen/widgets/list_note.dart';
import 'package:first_flutter_app/ui/note/ui/navigation_bar.dart';
import 'package:first_flutter_app/data/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  int _currentIndex = 0;

  void _onNavBarIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  AppBar _buildAppBar() {
    final titles = ["Money lover", "Reports"];
    final actions = [[], []];

    return AppBar(
      title: Text(
        titles[_currentIndex],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        ...actions[_currentIndex],
        IconButton(
          onPressed: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Logout'),
                content: Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Logout'),
                  ),
                ],
              ),
            );

            if (shouldLogout == true) {
              final authRepo = Provider.of<AuthRepository>(
                context,
                listen: false,
              );
              await authRepo.logout();
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          icon: Icon(Icons.logout, color: Colors.white),
          tooltip: 'Logout',
        ),
      ],
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
        CreateNote(
          onCreated: () {
            setState(() {
              _currentIndex = 1;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Created successfully!')));
          },
        ),
        ListNote(),
      ][_currentIndex],
      appBar: _buildAppBar(),
    );
  }
}
