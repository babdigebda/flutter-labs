class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime lastModified;
  String? currencyCode;
  double? currencyAmount;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastModified,
    this.currencyCode,
    this.currencyAmount,
  });

  Note copyWith({
    String? title,
    String? content,
    DateTime? lastModified,
    String? currencyCode,
    double? currencyAmount,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      lastModified: lastModified ?? this.lastModified,
      currencyCode: currencyCode ?? this.currencyCode,
      currencyAmount: currencyAmount ?? this.currencyAmount,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'lastModified': lastModified.toIso8601String(),
    'currencyCode': currencyCode,
    'currencyAmount': currencyAmount,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    lastModified: DateTime.parse(json['lastModified']),
    currencyCode: json['currencyCode'],
    currencyAmount: json['currencyAmount']?.toDouble(),
  );
}