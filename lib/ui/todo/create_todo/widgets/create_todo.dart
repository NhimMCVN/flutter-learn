import 'package:first_flutter_app/ui/todo/create_todo/widgets/input_form.dart';
import 'package:first_flutter_app/ui/todo/ui/category_item.dart';
import 'package:flutter/material.dart';

class CreateTodo extends StatefulWidget {
  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InputForm(
            initAmount: 125,
            initCate: Category("Cosmetic", Icons.face),
            initDescription: 'Test',
            type: EnumInputMoney.Revenue,
            initDate: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
            onChanged:
                (
                  String? description,
                  double? amount,
                  DateTime? date,
                  Category? category,
                  EnumInputMoney? inputType,
                ) {
                  print(
                    'Description: $description, Amount: $amount, Date: $date, Category: $category, InputType: $inputType',
                  );
                },
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {},
            child: Text("Create"),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
        ),
      ],
    );
  }
}
