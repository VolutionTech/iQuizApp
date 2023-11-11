class Category {
  final String id;
  final String name;
  final DateTime timestamp;

  Category({
    required this.id,
    required this.name,
    required this.timestamp,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
