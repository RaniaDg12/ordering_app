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
      'article': articleName,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

enum Priority {
  Faible,
  Moyenne,
  Eleve,
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
            (e) => e.toString() == 'Priority.${json['priority'] ?? 'Faible'}',
        orElse: () => Priority.Faible,
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
      'site': site,
      'client': clientName,
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


  int _currentStep = 0;
  Map<String, dynamic> _orderData = {
    'site': '',
    'client': '',
    'dateCommande': '',
    'dateLivraison': '',
    'articles': <Article>[],
    'priority': Priority.Faible,
    'observation': '',
  };
  int get currentStep => _currentStep;// Getter for current step
  Map<String, dynamic> get orderData => _orderData; // Getter for order data

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void incrementStep() {
    if (_currentStep < 2) {
      _currentStep++;
      print('Current Step: $_currentStep');
      notifyListeners();
    }
  }

  void decrementStep() {
    if (_currentStep > 0) {
      _currentStep--;
      print('Current Step: $_currentStep');
      notifyListeners();
    }
  }

  // Method to update order data fields
  void updateOrderData(String key, dynamic value) {
    _orderData[key] = value;
    print('Updated $_orderData');
    notifyListeners();
  }


  // Getter to fetch order data fields
  dynamic getOrderData(String key) {
    return _orderData[key];
  }



  Future<void> addOrder(Order order) async {
    AuthService authService = AuthService();
    String? token = await authService.getCurrentUserToken();

    print('Fetched token: $token');

    if (token != null) {
      try {
        _isLoading = true;
        notifyListeners();

        // Validate and ensure all required fields are populated
        final String site = order.site;
        final String clientName = order.clientName;
        final String dateCommande = order.dateCommande;
        final String dateLivraison = order.dateLivraison;
        final List<Article> articles = order.articles;
        final Priority priority = order.priority;
        final String observation = order.observation;

        // Debugging information
        print('site: $site');
        print('clientName: $clientName');
        print('dateCommande: $dateCommande');
        print('dateLivraison: $dateLivraison');
        print('articles: $articles');
        print('priority: $priority');
        print('observation: $observation');

        // Validate required fields are not empty
        if (site.isEmpty ||
            clientName.isEmpty ||
            dateCommande.isEmpty ||
            dateLivraison.isEmpty ||
            articles.isEmpty) {
          throw Exception('Required fields are missing');
        }

        print('Order: $order');

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


  Future<void> fetchOrderById(String id) async {
    AuthService authService = AuthService();
    String? token = await authService.getCurrentUserToken();

    print('Fetched token: $token');

    if (token != null) {
      try {
        _isLoading = true;
        notifyListeners();

        Order order = await _orderService.fetchOrderById(id, token);
        if (order != null) {
          _orders = [order];
        } else {
          _orders = [];
        }
      } catch (e) {
        print('Error fetching order by ID $e');
        _orders = []; // Clear the order on error
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      print('Token is null. User not authenticated.');
      _orders = []; // Clear the order if the user is not authenticated
      notifyListeners();
    }
  }

}

