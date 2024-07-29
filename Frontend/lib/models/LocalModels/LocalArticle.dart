import 'package:hive/hive.dart';

part 'LocalArticle.g.dart';


// LocalArticle class for Hive local storage in LocalOrder.dart
@HiveType(typeId: 1)
class LocalArticle extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String unit;

  LocalArticle({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });
}
