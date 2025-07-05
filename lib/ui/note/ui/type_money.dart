import 'package:first_flutter_app/ui/note/ui/category_item.dart';
import 'package:first_flutter_app/ui/note/ui/single_type.dart';
import 'package:flutter/material.dart';

class TypeMoney extends StatefulWidget {
  final EnumInputMoney initType;
  final ValueChanged<EnumInputMoney>? onChanged;

  TypeMoney({this.initType = EnumInputMoney.Spending, this.onChanged});

  @override
  State<TypeMoney> createState() {
    return _TypeMoneyState();
  }
}

class _TypeMoneyState extends State<TypeMoney> {
  late EnumInputMoney type;

  @override
  void initState() {
    super.initState();
    type = widget.initType;
  }

  @override
  void didUpdateWidget(covariant TypeMoney oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initType != widget.initType) {
      setState(() {
        type = widget.initType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SingleType(
          title: EnumInputMoney.Spending.name,
          onChanged: () {
            setState(() {
              type = EnumInputMoney.Spending;
            });
            widget.onChanged?.call(EnumInputMoney.Spending);
          },
          isSelected: type.name == EnumInputMoney.Spending.name,
        ),
        SingleType(
          title: EnumInputMoney.Revenue.name,
          onChanged: () {
            setState(() {
              type = EnumInputMoney.Revenue;
            });
            widget.onChanged?.call(EnumInputMoney.Revenue);
          },
          isSelected: type.name == EnumInputMoney.Revenue.name,
        ),
      ],
    );
  }
}
