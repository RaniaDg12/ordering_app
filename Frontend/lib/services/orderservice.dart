/* import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import 'authservice.dart';


class OrderService {
  static const String baseUrl = 'http://192.168.56.1:3000';

  Future<List<Order>> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Order.fromJson(item)).toList();
      } else {
        print('Failed to load orders - ${response.statusCode}: ${response.body}');
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Failed to load orders');
    }
  }

  Future<void> addOrder(Order order) async {
    final token = AuthService().getCurrentUserToken();

    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add order');
    }
  }
}
*/





/* import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../services/authservice.dart';

class OrderService {
  static const String baseUrl = 'http://192.168.56.1:3000';
  final AuthService _authService;

  OrderService(this._authService);

  Future<String?> _getToken() async {
    return await _authService.getCurrentUserToken();
  }

  Future<List<Order>> getOrders() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Order.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> createOrder(Order order) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(order.toJson()),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<Order> getOrder(String id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/orders/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<Order> updateOrder(String id, Order order) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/orders/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(order.toJson()),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update order');
    }
  }

  Future<void> deleteOrder(String id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/orders/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete order');
    }
  }
}
*/



import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://192.168.56.1:3000';

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
      final transformedOrder = await _transformOrder(order);

      final url = Uri.parse('$baseUrl/orders');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(transformedOrder),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _transformOrder(Order order) async {
    // Transform site
    final siteResponse = await http.get(
      Uri.parse('$baseUrl/sites?name=${order.site}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (siteResponse.statusCode != 200) {
      throw Exception('Failed to find site: ${order.site}');
    }

    final siteData = jsonDecode(siteResponse.body);
    final siteId = siteData['id'];

    // Transform client
    final clientResponse = await http.get(
      Uri.parse('$baseUrl/clients?name=${order.clientName}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (clientResponse.statusCode != 200) {
      throw Exception('Failed to find client: ${order.clientName}');
    }

    final clientData = jsonDecode(clientResponse.body);
    final clientId = clientData['id'];

    // Transform articles
    final transformedArticles = await Future.wait(order.articles.map((article) async {
      final articleResponse = await http.get(
        Uri.parse('$baseUrl/articles?name=${article.articleName}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (articleResponse.statusCode != 200) {
        throw Exception('Failed to find article: ${article.articleName}');
      }

      final articleData = jsonDecode(articleResponse.body);
      return {
        'article': articleData['id'],
        'quantity': article.quantity,
        'unit': article.unit,
      };
    }).toList());

    return {
      'site': siteId,
      'client': clientId,
      'dateCommande': order.dateCommande,
      'dateLivraison': order.dateLivraison,
      'articles': transformedArticles,
      'priority': order.priority.toString().split('.').last,
      'etatCommande': order.etatCommande.toString().split('.').last,
      'observation': order.observation,
    };
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
}
