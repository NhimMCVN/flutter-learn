import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:first_flutter_app/ui/note/ui/category_item.dart';
import 'package:flutter/material.dart';

class ListCategory extends StatefulWidget {
  final EnumInputMoney type;
  final void Function(CategoryUI cate)? onSelectedCate;
  final String? initSelectedKey;

  ListCategory(
    this.type, {
    this.onSelectedCate,
    this.initSelectedKey,
    super.key,
  });

  @override
  State<ListCategory> createState() {
    return _ListCategoryState();
  }
}

class _ListCategoryState extends State<ListCategory> {
  List<CategoryUI> listCategoryUI = [];
  CategoryUI? selectedCate;

  @override
  void initState() {
    super.initState();
    listCategoryUI = widget.type == EnumInputMoney.Spending
        ? getSpendingCategories()
        : getRevenueCategories();

    if (widget.initSelectedKey != null && widget.initSelectedKey!.isNotEmpty) {
      final CategoryUI foundCate = listCategoryUI.firstWhere(
        (ele) => ele.name == widget.initSelectedKey,
        orElse: () => CategoryUI(name: '', icon: Icons.help_outline),
      );
      selectedCate = foundCate.name.isNotEmpty ? foundCate : null;
    }

    if (selectedCate == null && listCategoryUI.isNotEmpty) {
      selectedCate = listCategoryUI.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelectedCate?.call(selectedCate!);
      });
    }
  }

  @override
  void didUpdateWidget(covariant ListCategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initSelectedKey != widget.initSelectedKey ||
        oldWidget.type != widget.type) {
      listCategoryUI = widget.type == EnumInputMoney.Spending
          ? getSpendingCategories()
          : getRevenueCategories();

      if (oldWidget.type != widget.type) {
        if (listCategoryUI.isNotEmpty) {
          selectedCate = listCategoryUI.first;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onSelectedCate?.call(selectedCate!);
          });
        } else {
          selectedCate = null;
        }
      } else {
        final CategoryUI foundCate = listCategoryUI.firstWhere(
          (ele) => ele.name == widget.initSelectedKey,
          orElse: () => CategoryUI(name: '', icon: Icons.help_outline),
        );
        selectedCate = foundCate.name.isNotEmpty ? foundCate : null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: listCategoryUI.length,
      itemBuilder: (context, index) {
        final item = listCategoryUI[index];
        return CategoryItem(
          item,
          onSelected: (cate) {
            widget.onSelectedCate?.call(cate);
            setState(() {
              selectedCate = cate;
            });
          },
          initValue: item.name == (selectedCate?.name ?? ""),
        );
      },
    );
  }
}
