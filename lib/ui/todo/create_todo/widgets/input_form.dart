import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleForm extends StatelessWidget {
  final String title;

  TitleForm({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(color: Colors.grey[700]));
  }
}

class InputForm extends StatefulWidget {
  final String? initDescription;
  final double? initAmount;
  final String? initDate;

  final void Function(String? description, double? amount, DateTime? date)?
  onChanged;
  const InputForm({
    super.key,
    this.initAmount,
    this.initDescription,
    this.initDate,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();

  String description = '';
  double amount = 0;
  DateTime date = DateTime.now();

  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: (widget.initAmount ?? 0).toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.initDescription ?? "",
    );
    _dateController = TextEditingController(
      text: widget.initDate ?? DateFormat("dd/MM/yyyy").format(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _emitChange() {
    final double amt = double.tryParse(_amountController.text) ?? 0;
    final String desc = _descriptionController.text;
    final DateTime selectedDate = date;
    widget.onChanged?.call(desc, amt, selectedDate);
  }

  List<Widget> divider = [
    SizedBox(height: 8),
    Divider(color: Colors.grey[300]),
    SizedBox(height: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scrollbar(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: TitleForm(title: "Amount")),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepPurple[50],
                          border: InputBorder.none,
                          suffix: Text(
                            '\$',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.deepPurple,
                        onChanged: (value) {
                          _emitChange();
                        },
                        controller: _amountController,
                      ),
                    ),
                  ],
                ),
                ...divider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: TitleForm(title: "Description")),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepPurple[50],
                          hintText: "Enter a description...",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          _emitChange();
                        },
                        controller: _descriptionController,
                      ),
                    ),
                  ],
                ),
                ...divider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: TitleForm(title: "Select date")),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepPurple[50],
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          var pickedDate = await showDatePicker(
                            context: context,
                            firstDate: date,
                            lastDate: DateTime(2050),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              date = pickedDate;
                            });
                            _dateController.text = DateFormat(
                              "dd/MM/yyyy",
                            ).format(pickedDate);
                            _emitChange();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
