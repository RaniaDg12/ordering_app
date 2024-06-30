import 'package:flutter/material.dart';

class Order {
  final String orderId;
  final String clientName;
  final String date;
  final int articlesCount;

  Order({
    required this.orderId,
    required this.clientName,
    required this.date,
    required this.articlesCount,
  });
}

class OrderModel extends ChangeNotifier {
  List<Order> _orders = [
    Order(orderId: "8461239752", clientName: "Client A", date: "12/06/2024", articlesCount: 2),
    Order(orderId: "8461239753", clientName: "Client B", date: "12/06/2024", articlesCount: 4),
    Order(orderId: "8461239754", clientName: "Client C", date: "12/06/2024", articlesCount: 2),
  ];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

// Add more methods for filtering or managing orders here
}
