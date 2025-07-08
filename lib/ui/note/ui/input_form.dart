import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:first_flutter_app/ui/note/ui/category_item.dart';
import 'package:first_flutter_app/ui/note/ui/common_input_row.dart';
import 'package:first_flutter_app/ui/note/ui/list_category.dart';
import 'package:first_flutter_app/ui/note/ui/type_money.dart';
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
  final CategoryUI? initCate;
  final EnumInputMoney? type;

  final void Function(
    String? description,
    double? amount,
    DateTime? date,
    CategoryUI? category,
    EnumInputMoney? type,
  )?
  onChanged;

  const InputForm({
    super.key,
    this.initAmount,
    this.initDescription,
    this.initDate,
    this.initCate,
    this.onChanged,
    this.type = EnumInputMoney.Spending,
  });

  @override
  State<StatefulWidget> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();

  CategoryUI? selectedCate;
  EnumInputMoney? selectedType;
  DateTime date = DateTime.now();

  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    selectedType = widget.type;
    _amountController = TextEditingController(
      text: (widget.initAmount ?? 0).toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.initDescription ?? "",
    );
    _dateController = TextEditingController(
      text: widget.initDate ?? DateFormat("dd/MM/yyyy").format(DateTime.now()),
    );
    selectedCate = widget.initCate;
  }

  @override
  void didUpdateWidget(covariant InputForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initAmount != oldWidget.initAmount) {
      _amountController.text = (widget.initAmount ?? 0).toString();
    }
    if (widget.initDescription != oldWidget.initDescription) {
      _descriptionController.text = widget.initDescription ?? "";
    }
    if (widget.initDate != oldWidget.initDate) {
      _dateController.text =
          widget.initDate ?? DateFormat("dd/MM/yyyy").format(DateTime.now());
    }
    if (widget.initCate?.name != oldWidget.initCate?.name) {
      selectedCate = widget.initCate;
    }
    if (widget.type != oldWidget.type) {
      selectedType = widget.type;
    }
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
    final EnumInputMoney? type = selectedType;
    widget.onChanged?.call(desc, amt, selectedDate, selectedCate, type);
  }

  List<Widget> divider = [
    SizedBox(height: 8),
    Divider(color: Colors.grey[300]),
    SizedBox(height: 8),
  ];

  Future<void> handleChangeDate() async {
    var pickedDate = await showDatePicker(
      context: context,
      firstDate: date,
      lastDate: DateTime(2050),
    );
    if (pickedDate != null) {
      setState(() {
        date = pickedDate;
      });
      _dateController.text = DateFormat("dd/MM/yyyy").format(pickedDate);
      _emitChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TypeMoney(
                    initType: selectedType ?? EnumInputMoney.Revenue,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  CommonInputRow(
                    title: "Amount",
                    controller: _amountController,
                    suffix: Text('\$', style: TextStyle(color: Colors.black)),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _emitChange(),
                  ),
                  ...divider,
                  CommonInputRow(
                    title: "Description",
                    controller: _descriptionController,
                    hintText: "Enter a description...",
                    onChanged: (value) => _emitChange(),
                  ),
                  ...divider,
                  CommonInputRow(
                    title: "Select date",
                    controller: _dateController,
                    readOnly: true,
                    suffixIcon: Icon(Icons.calendar_today),
                    onTap: handleChangeDate,
                  ),
                  ...divider,
                  SizedBox(
                    height: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleForm(title: "Category"),
                        SizedBox(height: 8),
                        Expanded(
                          child: ListCategory(
                            EnumInputMoney.Spending,
                            initSelectedKey: selectedCate?.name ?? '',
                            onSelectedCate: (cate) {
                              selectedCate = cate;
                              _emitChange();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
