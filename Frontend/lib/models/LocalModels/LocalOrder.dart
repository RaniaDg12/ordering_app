import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../order.dart';
import '../article.dart';
import 'LocalArticle.dart';
import '../enums/priority.dart';

part 'LocalOrder.g.dart';



// LocalOrder class using LocalArticle for local storage
@HiveType(typeId: 2)
class LocalOrder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String site;

  @HiveField(2)
  String clientName;

  @HiveField(3)
  String dateCommande;

  @HiveField(4)
  String dateLivraison;

  @HiveField(5)
  List<LocalArticle> articles;

  @HiveField(6)
  Priority priority;

  @HiveField(7)
  String etatCommande;

  @HiveField(8)
  String observation;

  @HiveField(9)
  bool isSynced;


  LocalOrder({
    String? id,
    required this.site,
    required this.clientName,
    required this.dateCommande,
    required this.dateLivraison,
    required this.articles,
    required this.priority,
    required this.etatCommande,
    required this.observation,
    this.isSynced = false,
  }): id = id ?? const Uuid().v4();

  factory LocalOrder.fromOrder(Order order) {
    return LocalOrder(
      id: order.id.isNotEmpty ? order.id : Uuid().v4(),
      site: order.site,
      clientName: order.clientName,
      dateCommande: order.dateCommande,
      dateLivraison: order.dateLivraison,
      articles: order.articles.map((article) => LocalArticle(
        id: article.id,
        name: article.articleName,
        quantity: article.quantity,
        unit: article.unit,
      )).toList(),
      priority: order.priority,
      etatCommande: order.etatCommande,
      observation: order.observation,
    );
  }

  Order toOrder() {
    return Order(
      id: id,
      site: site,
      clientName: clientName,
      dateCommande: dateCommande,
      dateLivraison: dateLivraison,
      articles: articles.map((localArticle) => Article(
        id: localArticle.id,
        articleName: localArticle.name,
        quantity: localArticle.quantity,
        unit: localArticle.unit,
      )).toList(),
      priority: priority,
      etatCommande: etatCommande,
      observation: observation,
    );
  }
}
