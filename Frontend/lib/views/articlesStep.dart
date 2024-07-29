import 'package:flutter/material.dart';
import '../models/article.dart';
import '../providers/OrderStepProvider.dart';

class ArticlesStep extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final Function(String, dynamic) onUpdate;

  ArticlesStep({super.key, required this.orderData, required this.onUpdate});

  final List<String> articles = ['huile de mais', 'huile de tournesol'];
  final List<String> units = ['Lt', 'daL', 'kL'];

  @override
  Widget build(BuildContext context) {
    print('Current Order Data in ArticleStep: $orderData');

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choisir un article',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              value: orderData['article'],
              items: articles.map((article) {
                return DropdownMenuItem(value: article, child: Text(article));
              }).toList(),
              onChanged: (value) {
                orderData['article'] = value!;
                onUpdate('article', value);
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choisir une unité',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              value: orderData['unit'],
              items: units.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                orderData['unit'] = value!;
                onUpdate('unit', value);
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Quantité',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int? quantity = int.tryParse(value);
                if (quantity != null) {
                  orderData['quantity'] = quantity;
                  onUpdate('quantity', quantity);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _addArticleToOrder();
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Ajouter un article', style: TextStyle(fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[200],
            ),
          ),
          const SizedBox(height: 16),
          _buildArticleList(),
        ],
      ),
    );
  }

  void _addArticleToOrder() {
    // Ensure orderData['articles'] is initialized as a List if null
    orderData['articles'] ??= [];

    int quantity = orderData['quantity'] ?? 0;

    // Create a map representing the article and add it to the list
    Article article = Article(
      id: '', // Ensure to assign proper IDs if necessary
      articleName: orderData['article'] as String,
      quantity: quantity,
      unit: orderData['unit'] as String,
    );

    // Add article to the list
    orderData['articles'].add(article);

    // Clear fields after adding article
    orderData['article'] = null;
    orderData['unit'] = null;
    orderData['quantity'] = null;

    // Notify parent widget about articles update
    onUpdate('articles', orderData['articles']);
  }

  Widget _buildArticleList() {
    if (orderData['articles'] == null || orderData['articles'].isEmpty) {
      return const SizedBox.shrink();
    }

    // Map each Article to a ListTile in a Card
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderData['articles'].length,
      itemBuilder: (context, index) {
        Article article = orderData['articles'][index] as Article;
        return Card(
          child: ListTile(
            title: Text(article.articleName),
            trailing: Text(
              '${article.quantity} ${article.unit}',
              style: const TextStyle(color: Colors.green),
            ),
          ),
        );
      },
    );
  }
}
