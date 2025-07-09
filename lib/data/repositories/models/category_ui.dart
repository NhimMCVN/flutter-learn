import 'package:flutter/material.dart';

final int spending = 0;
final int revenue = 1;

final List<CategoryUI> listAllCategories = [
  CategoryUI(name: "Cosmetic", icon: Icons.face, type: spending),
  CategoryUI(name: "Food", icon: Icons.fastfood, type: spending),
  CategoryUI(name: "Travel", icon: Icons.flight, type: spending),
  CategoryUI(name: "Education", icon: Icons.book, type: spending),
  CategoryUI(name: "Family", icon: Icons.family_restroom, type: spending),
  CategoryUI(name: "Pharmar", icon: Icons.local_pharmacy, type: spending),
  CategoryUI(name: "Salary", icon: Icons.attach_money, type: revenue),
  CategoryUI(name: "Bonus", icon: Icons.card_giftcard, type: revenue),
  CategoryUI(name: "Investment", icon: Icons.trending_up, type: revenue),
  CategoryUI(name: "Gift", icon: Icons.card_giftcard, type: revenue),
  CategoryUI(name: "Interest", icon: Icons.savings, type: revenue),
  CategoryUI(name: "Other", icon: Icons.more_horiz, type: revenue),
];

List<CategoryUI> getSpendingCategories() {
  return listAllCategories.where((e) => e.type == spending).toList();
}

List<CategoryUI> getRevenueCategories() {
  return listAllCategories.where((e) => e.type == revenue).toList();
}

CategoryUI getCategoryUI(String name) {
  return listAllCategories.firstWhere(
    (element) => element.name == name,
    orElse: () =>
        CategoryUI(name: "Other", icon: Icons.more_horiz, type: spending),
  );
}

class CategoryUI {
  final int? id;
  final int? type;
  final String name;
  final IconData icon;

  CategoryUI({this.id, this.type, required this.name, required this.icon});
}
