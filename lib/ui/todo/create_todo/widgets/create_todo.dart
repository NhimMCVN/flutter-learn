import 'package:first_flutter_app/ui/todo/create_todo/widgets/spending_form.dart';
import 'package:flutter/material.dart';

class CreateTodo extends StatelessWidget {

  const CreateTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [Tab(text: "Spending",), Tab(text: "Revenue",)],
            dividerColor: Colors.grey[200],
            indicatorColor: Colors.deepPurple,
            labelStyle: TextStyle(
              color: Colors.deepPurple,
              fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
              fontWeight: Theme.of(context).textTheme.labelLarge?.fontWeight
            ),
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              children: [SpendingForm()],
            ),
          ),
        ],
      ),
    );
  }
}
