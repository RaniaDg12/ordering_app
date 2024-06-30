import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/orderList.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrder> {
  int _currentStep = 0;
  final _orderData = {
    'site': '',
    'client': '',
    'dateCommande': '',
    'dateLivraison': '',
    'articles': [],
    'priority': '',
    'observation': ''
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Commande'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal, // Changed to horizontal view
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep++;
            });
          } else {
            _showConfirmationDialog();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          } else {
            Navigator.pop(context);
          }
        },
        steps: [
          Step(
            title: Text('Client', style: TextStyle(color: Colors.green)),
            subtitle: Text(''), // No subtitle needed
            content: ClientStep(orderData: _orderData),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text('Articles', style: TextStyle(color: Colors.green)),
            subtitle: Text(''), // No subtitle needed
            content: ArticlesStep(orderData: _orderData),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: Text('Autres', style: TextStyle(color: Colors.green)),
            subtitle: Text(''), // No subtitle needed
            content: AutresStep(orderData: _orderData),
            isActive: _currentStep >= 2,
          ),
        ],
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (_currentStep != 0)
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Text('Précédent',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Text(_currentStep == 2 ? 'Valider' : 'Suivant',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to add this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentStep = 0;
                });
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addOrder();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  void _addOrder() {
    final orderModel = Provider.of<OrderModel>(context, listen: false);
    final newOrder = Order(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      clientName: _orderData['client'] as String,
      date: _orderData['dateCommande'] as String,
      articlesCount: (_orderData['articles'] as List).length,
    );
    orderModel.addOrder(newOrder);
    Navigator.pop(context);
  }
}

class ClientStep extends StatelessWidget {
  final Map<String, dynamic> orderData;

  ClientStep({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Choisir un site',
            prefixIcon: Icon(Icons.map),
            border: OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(child: Text('Site 1'), value: 'site1'),
            DropdownMenuItem(child: Text('Site 2'), value: 'site2'),
          ],
          onChanged: (value) {
            orderData['site'] = value!;
          },
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Choisir un client',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(child: Text('Client A'), value: 'clientA'),
            DropdownMenuItem(child: Text('Client B'), value: 'clientB'),
          ],
          onChanged: (value) {
            orderData['client'] = value!;
          },
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Date de Commande',
            border: OutlineInputBorder(),
          ),
          onTap: () {
            // Add date picker functionality
          },
          onChanged: (value) {
            orderData['dateCommande'] = value;
          },
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Date de Livraison',
            border: OutlineInputBorder(),
          ),
          onTap: () {
            // Add date picker functionality
          },
          onChanged: (value) {
            orderData['dateLivraison'] = value;
          },
        ),
      ],
    );
  }
}

class ArticlesStep extends StatefulWidget {
  final Map<String, dynamic> orderData;

  ArticlesStep({required this.orderData});

  @override
  _ArticlesStepState createState() => _ArticlesStepState();
}

class _ArticlesStepState extends State<ArticlesStep> {
  final _articleController = TextEditingController();
  final _unitController = TextEditingController();
  final _quantityController = TextEditingController();

  void _addArticle() {
    setState(() {
      widget.orderData['articles'].add({
        'article': _articleController.text,
        'unit': _unitController.text,
        'quantity': _quantityController.text,
      });
      _articleController.clear();
      _unitController.clear();
      _quantityController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Choisir un article',
            border: OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(child: Text('Article 1'), value: 'article1'),
            DropdownMenuItem(child: Text('Article 2'), value: 'article2'),
          ],
          onChanged: (value) {
            _articleController.text = value!;
          },
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Choisir une unité',
            border: OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(child: Text('Unit 1'), value: 'unit1'),
            DropdownMenuItem(child: Text('Unit 2'), value: 'unit2'),
          ],
          onChanged: (value) {
            _unitController.text = value!;
          },
        ),
        SizedBox(height: 16),
        TextField(
          controller: _quantityController,
          decoration: InputDecoration(
            labelText: 'Saisir quantité',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _addArticle,
          icon: Icon(Icons.add),
          label: Text('Ajouter un article'),
        ),
        SizedBox(height: 16),
        ...widget.orderData['articles'].map<Widget>((article) {
          return Card(
            child: ListTile(
              title: Text(article['article']),
              trailing: Text(
                '${article['quantity']} ${article['unit']}',
                style: TextStyle(color: Colors.green),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class AutresStep extends StatelessWidget {
  final Map<String, dynamic> orderData;

  AutresStep({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Choisir priorité commande',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            orderData['priority'] = value;
          },
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Observation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            orderData['observation'] = value;
          },
        ),
      ],
    );
  }
}
