import 'package:flutter/material.dart';

class NavigationBarWrapper extends StatefulWidget {
  final ValueChanged<int>? onIndexChanged;
  final int initIndex;
  NavigationBarWrapper({super.key, this.onIndexChanged, this.initIndex = 0});

  @override
  State<StatefulWidget> createState() => _NavigationBarWrapperState();
}

class _NavigationBarWrapperState extends State<NavigationBarWrapper> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initIndex;
  }

  @override
  void didUpdateWidget(covariant NavigationBarWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initIndex != oldWidget.initIndex) {
      setState(() {
        currentPageIndex = widget.initIndex;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.deepPurple[50],
      indicatorColor: Colors.deepPurple[300],
      selectedIndex: currentPageIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentPageIndex = index;
        });
        widget.onIndexChanged?.call(index);
      },
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.create),
          label: 'Create',
          selectedIcon: Icon(Icons.create_outlined),
        ),
        NavigationDestination(
          icon: Icon(Icons.list),
          label: 'Expense',
          selectedIcon: Icon(Icons.list_outlined),
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Settings',
          selectedIcon: Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
