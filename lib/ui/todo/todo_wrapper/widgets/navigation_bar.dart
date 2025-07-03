import 'package:flutter/material.dart';

class NavigationBarWrapper extends StatefulWidget {
  ValueChanged<int>? onIndexChanged;
  NavigationBarWrapper({super.key, this.onIndexChanged});

  @override
  State<StatefulWidget> createState() => _NavigationBarWrapperState();
}


class _NavigationBarWrapperState extends State<NavigationBarWrapper>{
  int currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NavigationBarWrapper oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.deepPurple[50],
      indicatorColor: Colors.deepPurple[300],
      selectedIndex: currentPageIndex,
      onDestinationSelected: (index){
        print("index $index");
        setState(() {
          currentPageIndex = index;
        });
        widget.onIndexChanged?.call(index);
      },
      destinations: [
        NavigationDestination(icon: Icon(Icons.create), label: 'Create', selectedIcon: Icon(Icons.create_outlined)),
        NavigationDestination(icon: Icon(Icons.list), label: 'Expense', selectedIcon: Icon(Icons.list_outlined)),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Settings', selectedIcon: Icon(Icons.settings_outlined))
      ],
    );
  }
}