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
      date: _parseDate(json["date"]),
      category: cate,
      type: json["type"],
    );
  }

  factory NoteModelUI.fromModel(NoteModel model) {
    return NoteModelUI(
      id: model.id != null ? int.tryParse(model.id!) : null,
      amount: model.amount,
      description: model.description,
      date: _parseDate(model.date),
      category: getCategoryUI(model.category),
      type: model.type,
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) {
      return DateTime.now();
    }

    if (date is DateTime) {
      return date;
    }

    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        try {
          final timestamp = int.parse(date);
          if (timestamp > 9999999999) {
            return DateTime.fromMillisecondsSinceEpoch(timestamp);
          } else {
            return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          }
        } catch (e) {
          return DateTime.now();
        }
      }
    }

    if (date is int) {
      if (date > 9999999999) {
        return DateTime.fromMillisecondsSinceEpoch(date);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(date * 1000);
      }
    }

    if (date is double) {
      if (date > 9999999999) {
        return DateTime.fromMillisecondsSinceEpoch(date.toInt());
      } else {
        return DateTime.fromMillisecondsSinceEpoch((date * 1000).toInt());
      }
    }

    return DateTime.now();
  }
}
