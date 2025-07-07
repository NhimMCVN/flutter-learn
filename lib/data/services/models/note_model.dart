class NoteModel {
  final String? id;
  final String description;
  final double amount;
  final String date;
  final String category;
  final int type;

  NoteModel({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json["id"],
      description: json["description"],
      amount: json["amount"],
      date: json["date"],
      category: json["category"],
      type: json["type"],
    );
  }
  NoteModel copyWith({
    String? id,
    String? description,
    double? amount,
    String? date,
    String? category,
    int? type,
  }) {
    return NoteModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'amount': amount,
    'date': date,
    'category': category,
    'type': type,
  };
}
