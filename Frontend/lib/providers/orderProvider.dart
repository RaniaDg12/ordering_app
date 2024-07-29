import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../utils/utils.dart';

import '../services/orderservice.dart';
import '../services/authservice.dart';
import '../models/LocalModels/LocalOrder.dart';
import '../models/article.dart';
import '../models/order.dart';


class OrderModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  final Box<LocalOrder> _localOrderBox = Hive.box<LocalOrder>('orders');

  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;


  Future<void> addLocalOrder(Order order) async {
    try {
      final localOrder = LocalOrder.fromOrder(order);
      _localOrderBox.add(localOrder);
      print('Order added to local database');
      notifyListeners();
    } catch (e) {
      print('Error saving order locally: $e');
    }
  }

  Future<void> addOrder(Order order) async {
    // Check connectivity status
    if (await Utils.checkNetworkConnectivity()) {
      // Offline: Save to local database (Hive)
      await addLocalOrder(order);

    } else {
      // Online: Add to backend and sync local database
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

          // Validate required fields are not empty
          if (site.isEmpty ||
              clientName.isEmpty ||
              dateCommande.isEmpty ||
              dateLivraison.isEmpty ||
              articles.isEmpty) {
            throw Exception('Required fields are missing');
          }

          await _orderService.createOrder(order, token);
          orders.insert(0, order);
          notifyListeners();

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


  Future<List<Order>> fetchLocalOrders() async {
    try {
      List<LocalOrder> localOrders = Hive.box<LocalOrder>('orders').values.toList();
      List<Order> orders = localOrders.map((localOrder) => localOrder.toOrder()).toList();
      print('Local orders: $orders');
      _orders = orders;
      notifyListeners();

      return orders;
    } catch (e) {
      print('Error fetching local orders: $e');
      return [];
    }
  }


  Future<List<Order>> fetchOrders() async {
    try {
      // Fetch local orders first
      List<Order> localOrders = await fetchLocalOrders();

      // Check network connectivity
      if (!(await Utils.checkNetworkConnectivity())) {
        // Online: Fetch orders from backend
        AuthService authService = AuthService();
        String? token = await authService.getCurrentUserToken();

        print('Fetched token: $token');

        if (token != null) {
          try {
            _isLoading = true;
            notifyListeners();

            List<Order> backendOrders = await _orderService.fetchOrders(token);

            // Combine local and backend orders
            _orders = [...localOrders, ...backendOrders];
            notifyListeners();

          } catch (e) {
            print('Error fetching orders from backend: $e');
            // If there's an error fetching from backend, return local orders only
            _orders = localOrders;
            notifyListeners();

          } finally {
            _isLoading = false;
            notifyListeners();
          }
        } else {
          print('Token is null. User not authenticated.');
        }
      } else {
        // Offline: Return local orders only
        _orders = localOrders;
        notifyListeners();
      }

      return _orders;
    } catch (e) {
      print('Error in fetchOrders method: $e');
      return [];
    }
  }


  Future<void> fetchByStatus(String etatCommande) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch local orders by status
      List<LocalOrder> localOrders = Hive.box<LocalOrder>('orders')
          .values
          .where((localOrder) => localOrder.etatCommande == etatCommande)
          .toList();
      List<Order> localOrderList = localOrders.map((localOrder) => localOrder.toOrder()).toList();

      // Check network connectivity
      if (!(await Utils.checkNetworkConnectivity())) {
        // Online: Fetch orders from backend by status
        AuthService authService = AuthService();
        String? token = await authService.getCurrentUserToken();

        print('Fetched token: $token');

        if (token != null) {
          try {
            List<Order> backendOrders = await _orderService.fetchByStatus(etatCommande, token);
            // Combine local and backend orders
            _orders = [...localOrderList, ...backendOrders];
            notifyListeners();

          } catch (e) {
            print('Error fetching orders from backend: $e');
            // If there's an error fetching from backend, use local orders only
            _orders = localOrderList;
          }
        } else {
          print('Token is null. User not authenticated.');

        }
      } else {
        // Offline: Use local orders only
        _orders = localOrderList;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching orders by status: $e');
      _orders = []; // Clear the orders on error
      notifyListeners();

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> synchronizeLocalOrders(BuildContext context) async {
    if (!(await Utils.checkNetworkConnectivity())) {
      AuthService authService = AuthService();
      String? token = await authService.getCurrentUserToken();

      if (token != null) {
        List<LocalOrder> localOrders = Hive.box<LocalOrder>('orders').values.toList();

        if (localOrders.isNotEmpty) {
          try {
            for (LocalOrder localOrder in localOrders) {
              Order order = localOrder.toOrder();
              await OrderService().createOrder(order, token);
              await Hive.box<LocalOrder>('orders').delete(localOrder.key);
            }
            _orders.clear();
            notifyListeners();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'Synchronisation réussie. Toutes les commandes en cours ont été téléchargées.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Fetch local orders again to update the UI
            await fetchLocalOrders();
          } catch (e) {
            print('Erreur lors de la synchronisation des commandes: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'Erreur lors de la synchronisation des commandes.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Aucune commande à synchroniser.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                'Token is null. User not authenticated.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Text(
              'Pas de connexion Internet. Impossible de synchroniser les commandes.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
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
        _orders = [order];
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
