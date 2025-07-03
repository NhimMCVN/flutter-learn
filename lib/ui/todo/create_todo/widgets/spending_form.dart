import 'package:first_flutter_app/ui/todo/create_todo/widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SpendingForm extends StatefulWidget {
  @override
  State<SpendingForm> createState() => _SpendingFormState();
}

class _SpendingFormState extends State<SpendingForm> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Expanded(child: InputForm()),
        Spacer(),
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
