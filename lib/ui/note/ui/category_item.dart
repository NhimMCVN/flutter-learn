
import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:flutter/material.dart';
 
enum EnumInputMoney { Spending, Revenue }

final List<CategoryUI> listSpendingCate = getSpendingCategories();
final List<CategoryUI> listRevenueCate = getRevenueCategories();

class CategoryItem extends StatefulWidget {
  final void Function(CategoryUI cate)? onSelected;
  final bool? initValue;
  final CategoryUI cate;

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
