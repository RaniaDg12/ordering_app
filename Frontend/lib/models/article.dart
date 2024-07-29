class Article {
  final String id;
  final String articleName;
  final int quantity;
  final String unit;

  Article({
    required this.id,
    required this.articleName,
    required this.quantity,
    required this.unit,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id'] ?? '',
      articleName: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article': articleName,
      'quantity': quantity,
      'unit': unit,
    };
  }
}
