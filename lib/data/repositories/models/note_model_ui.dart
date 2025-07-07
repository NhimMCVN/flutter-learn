import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:first_flutter_app/data/services/models/note_model.dart';

class NoteModelUI {
  final int? id;
  final double amount;
  final String description;
  final DateTime date;
  final CategoryUI category;
  final int type;

  NoteModelUI({
    this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    required this.type,
  });
  factory NoteModelUI.fromJson(Map<String, dynamic> json) {
    final cate = getCategoryUI(json["category"] as String);

    return NoteModelUI(
      id: json["id"],
      description: json["description"] ?? '',
      amount: (json["amount"] as num).toDouble(),
      date: DateTime.parse(json["date"]),
      category: cate,
      type: json["type"],
    );
  }
  factory NoteModelUI.fromModel(NoteModel model) {
    return NoteModelUI(
      id: model.id != null ? int.tryParse(model.id!) : null,
      amount: model.amount,
      description: model.description,
      date: DateTime.parse(model.date),
      category: getCategoryUI(model.category), 
      type: model.type,
    );
  }

}
