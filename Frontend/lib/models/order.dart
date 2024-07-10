/* import 'package:flutter/material.dart';
import '../services/orderservice.dart';


class Order {
  final String orderId;
  final String site;
  final String clientName;
  final String dateCommande;
  final String dateLivraison;
  final List<Article> articles;
  final Priority priority;
  final String observation;

  Order({
    required this.orderId,
    required this.site,
    required this.clientName,
    required this.dateCommande,
    required this.dateLivraison,
    required this.articles,
    required this.priority,
    required this.observation,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      site: json['site'],
      clientName: json['clientName'],
      dateCommande: json['dateCommande'],
      dateLivraison: json['dateLivraison'],
      articles: (json['articles'] as List)
          .map((i) => Article.fromJson(i))
          .toList(),
      priority: Priority.values[json['priority']],
      observation: json['observation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'site': site,
      'clientName': clientName,
      'dateCommande': dateCommande,
      'dateLivraison': dateLivraison,
      'articles': articles.map((i) => i.toJson()).toList(),
      'priority': priority.index,
      'observation': observation,
    };
  }
}

class Article {
  final String name;
  final int quantity;
  final String unit;

  Article({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

enum Priority { low, medium, high }


class OrderModel extends ChangeNotifier {
  List<Order> _orders = [];
  OrderService _orderService = OrderService();

  List<Order> get orders => _orders;

  Future<void> fetchOrders() async {
    _orders = await _orderService.fetchOrders();
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    await _orderService.addOrder(order);
    await fetchOrders();
  }
}


*/




/* import 'package:flutter/material.dart';

class Article {
  final String name;
  final int quantity;
  final String unit;

  Article({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      name: json['article'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

enum Priority { eleve, moyenne, faible }
enum Status { Termine, Encours }

class Order {
  final String dateCommande;
  final String dateLivraison;
  final Status etatCommande;
  final Priority priority;
  final String user;
  final String client;
  final String site;
  final List<Article> articles;
  final String observation;

  Order({
    required this.dateCommande,
    required this.dateLivraison,
    required this.etatCommande,
    required this.priority,
    required this.user,
    required this.client,
    required this.site,
    required this.articles,
    required this.observation,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      dateCommande: json['dateCommande'],
      dateLivraison: json['dateLivraison'],
      etatCommande: Status.values.firstWhere((e) => e.toString() == 'Status.${json['etatCommande']}'),
      priority: Priority.values.firstWhere((e) => e.toString() == 'Priority.${json['priority']}'),
      user: json['user'],
      client: json['client'],
      site: json['site'],
      articles: (json['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList(),
      observation: json['observation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateCommande': dateCommande,
      'dateLivraison': dateLivraison,
      'etatCommande': etatCommande.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'user': user,
      'client': client,
      'site': site,
      'articles': articles.map((article) => article.toJson()).toList(),
      'observation': observation,
    };
  }
}
*/




/* import 'package:flutter/material.dart';

enum Priority {
  faible,
  moyenne,
  eleve,
}

class Article {
  final String articleName;
  final int quantity;
  final String unit;

  Article({
    required this.articleName,
    required this.quantity,
    required this.unit,
  });
}

class Order {
  final String orderId;
  final String site;
  final String clientName;
  final String dateCommande;
  final String dateLivraison;
  final List<Article> articles;
  final Priority priority;
  final String observation;

  Order({
    required this.orderId,
    required this.site,
    required this.clientName,
    required this.dateCommande,
    required this.dateLivraison,
    required this.articles,
    required this.priority,
    required this.observation,
  });
}

class OrderModel extends ChangeNotifier {
  List<Order> _orders = [
    Order(
      orderId: "8461239752",
      site: "Site A",
      clientName: "Client A",
      dateCommande: "12/06/2024",
      dateLivraison: "15/06/2024",
      articles: [
        Article(articleName: "Article 1", quantity: 2, unit: "pcs"),
        Article(articleName: "Article 2", quantity: 3, unit: "pcs"),
      ],
      priority: Priority.moyenne,
      observation: "Some observations here.",
    ),
    Order(
      orderId: "8461239753",
      site: "Site B",
      clientName: "Client B",
      dateCommande: "12/06/2024",
      dateLivraison: "14/06/2024",
      articles: [
        Article(articleName: "Article 3", quantity: 1, unit: "kg"),
        Article(articleName: "Article 4", quantity: 2, unit: "kg"),
        Article(articleName: "Article 5", quantity: 1, unit: "kg"),
      ],
      priority: Priority.eleve,
      observation: "No specific observations.",
    ),
  ];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

} */



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/orderservice.dart';
import '../services/authservice.dart';

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
      '_id': id,
      'name': articleName,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

enum Priority {
  faible,
  moyenne,
  eleve,
}
enum Status {
  Termine,
  Encours
}

class Order {
  final String id;
  final String site;
  final String clientName;
  final String dateCommande;
  final String dateLivraison;
  final List<Article> articles;
  final Priority priority;
  final Status etatCommande;
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
            (e) => e.toString() == 'Priority.${json['priority'] ?? 'faible'}',
        orElse: () => Priority.faible,
      ),
      observation: json['observation'] ?? '',
      etatCommande: Status.values.firstWhere(
            (e) => e.toString() == 'Status.${json['etatCommande'] ?? 'Encours'}',
        orElse: () => Status.Encours,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'site': site,
      'clientName': clientName,
      'dateCommande': dateCommande,
      'dateLivraison': dateLivraison,
      'articles': articles.map((article) => article.toJson()).toList(),
      'priority': priority.toString().split('.').last,
      'etatCommande': etatCommande.toString().split('.').last,
      'observation': observation,
    };
  }
}

class OrderModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<List<Order>> fetchOrders() async {
    AuthService authService = AuthService();
    String? token = await authService.getCurrentUserToken();

    print('Fetched token: $token');

    if (token != null) {
      try {
        _isLoading = true;
        notifyListeners();

        _orders = await _orderService.fetchOrders(token);
        return _orders;
      } catch (e) {
        print('Error fetching orders $e');
        return [];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      print('Token is null. User not authenticated.');
      return [];
    }
  }


  Future<void> fetchByStatus(String etatCommande) async {
    AuthService authService = AuthService();
    String? token = await authService.getCurrentUserToken();

    print('Fetched token: $token');

    if (token != null) {
      try {
        _isLoading = true;
        notifyListeners();

        _orders = await _orderService.fetchByStatus(etatCommande, token);
      } catch (e) {
        print('Error fetching orders by status $e');
        _orders = []; // Clear the orders on error
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      print('Token is null. User not authenticated.');
      _orders = []; // Clear the orders if the user is not authenticated
      notifyListeners();
    }
  }


  Future<void> createOrder(Order order) async {
    AuthService authService = AuthService();
    String? token = await authService.getCurrentUserToken();

    print('Fetched token: $token');

    if (token != null) {
      try {
        _isLoading = true;
        notifyListeners();

        await _orderService.createOrder(order, token);

        // Refresh the orders list after creating a new order
        await fetchOrders();
      } catch (e) {
        print('Error creating order $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      print('Token is null. User not authenticated.');
    }
  }

}

