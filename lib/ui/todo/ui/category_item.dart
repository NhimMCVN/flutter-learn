
import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  Category(this.name, this.icon);
}

enum EnumInputMoney { Spending, Revenue }

final List<Category> listSpendingCate = [
  Category("Cosmetic", Icons.face),
  Category("Food", Icons.fastfood),
  Category("Travel", Icons.flight),
  Category("Education", Icons.book),
  Category("Family", Icons.family_restroom),
  Category("Pharmar", Icons.local_pharmacy),
];

final List<Category> listRevenueCate = [
  Category("Salary", Icons.attach_money),
  Category("Bonus", Icons.card_giftcard),
  Category("Investment", Icons.trending_up),
  Category("Gift", Icons.card_giftcard),
  Category("Interest", Icons.savings),
  Category("Other", Icons.more_horiz),
];

class CategoryItem extends StatefulWidget {
  final void Function(Category cate)? onSelected;
  final bool? initValue;
  final Category cate;

  CategoryItem(this.cate, {this.initValue = false, this.onSelected, super.key});

  @override
  State<CategoryItem> createState() {
    return _CategoryItemState();
  }
}

class _CategoryItemState extends State<CategoryItem> {
  bool? isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initValue;
  }

  @override
  void didUpdateWidget(covariant CategoryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initValue != widget.initValue) {
      isSelected = widget.initValue ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected?.call(widget.cate);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected == true
                ? Colors.purple
                : (Colors.grey[300] ?? Colors.grey),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.cate.icon, size: 32),
              Text(widget.cate.name),
            ],
          ),
        ),
      ),
    );
  }
}
