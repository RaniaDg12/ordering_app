import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../constants/constants.dart';

class OrderService {

  Future<List<Order>> fetchOrders(String token) async {
    try {
      final url = Uri.parse('$baseUrl/orders');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    }catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<void> createOrder(Order order, String token) async {
    try {
      final url = Uri.parse('$baseUrl/orders');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(order.toJson()),
      );
      print('Order final:${jsonEncode(order.toJson())}');

      if (response.statusCode != 201) {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<List<Order>> fetchByStatus(String etatCommande, String token) async {
    try {
      final url = Uri.parse('$baseUrl/orders/status/$etatCommande');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders by status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders by status: $e');
      rethrow;
    }
  }

  Future<Order> fetchOrderById(String id, String token) async {
    try {
      final url = Uri.parse('$baseUrl/orders/$id');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Order.fromJson(responseData);
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching order: $e');
      rethrow;
    }
  } 

}
