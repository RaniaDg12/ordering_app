import '../models/article.dart';
import 'enums/priority.dart';

class Order {
  final String id;
  final String site;
  final String clientName;
  final String dateCommande;
  final String dateLivraison;
  final List<Article> articles;
  final Priority priority;
  final String etatCommande;
  final String observation;

  Order({
    required this.id,
    required this.site,
    required this.clientName,
    required this.dateCommande,
    required this.dateLivraison,
    required this.articles,
    required this.priority,
    required this.etatCommande,
    required this.observation,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var articlesList = json['articles'] as List;
    List<Article> articles = articlesList.map((articleJson) => Article.fromJson(articleJson)).toList();

    return Order(
      id: json['_id'] ?? '',
      site: json['site'] ?? '',
      clientName: json['client'] ?? '',
      dateCommande: json['dateCommande'] ?? '',
      dateLivraison: json['dateLivraison'] ?? '',
      articles: articles,
      priority: Priority.values.firstWhere(
            (e) => e.toString() == 'Priority.${json['priority'] ?? 'Faible'}',
        orElse: () => Priority.Faible,
      ),
      observation: json['observation'] ?? '',
      etatCommande: json['etatCommande'] ?? 'Encours',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site': site,
      'client': clientName,
      'dateCommande': dateCommande,
      'dateLivraison': dateLivraison,
      'articles': articles.map((article) => article.toJson()).toList(),
      'priority': priority.toString().split('.').last,
      'etatCommande': etatCommande,
      'observation': observation,
    };
  }
}

