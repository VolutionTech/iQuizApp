class Category {
  final String id;
  final String name;
  final int totalQuestions;
  final DateTime timestamp;

  Category({
    required this.id,
    required this.name,
    required this.totalQuestions,
    required this.timestamp,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      totalQuestions: json['totalQuestions'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
