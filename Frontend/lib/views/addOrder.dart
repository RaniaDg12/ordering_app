import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../services/authservice.dart';
import 'clientStep.dart';
import 'articlesStep.dart';
import 'autresStep.dart';

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
    'articles': <Article>[],
    'priority': Priority.faible,
    'observation': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Commande'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EasyStepper(
              activeStep: _currentStep,
              stepShape: StepShape.circle,
              stepRadius: 32,
              finishedStepBorderColor: Colors.green,
              finishedStepTextColor: Colors.green,
              finishedStepBackgroundColor: Colors.green,
              activeStepIconColor: Colors.green,
              showLoadingAnimation: false,
              steps: [
                EasyStep(
                  icon: Icon(Icons.person),
                  customTitle: const Text(
                    'Client',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
                EasyStep(
                  icon: Icon(Icons.article),
                  customTitle: const Text(
                    'Articles',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
                EasyStep(
                  icon: Icon(Icons.more_horiz),
                  customTitle: const Text(
                    'Autres',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ],
              onStepReached: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: _getStepContent(),
              ),
            ),
            _buildStepControls(),
          ],
        ),
      ),
    );
  }

  Widget _getStepContent() {
    switch (_currentStep) {
      case 0:
        return ClientStep(orderData: _orderData);
      case 1:
        return ArticlesStep(orderData: _orderData);
      case 2:
        return AutresStep(orderData: _orderData);
      default:
        return ClientStep(orderData: _orderData);
    }
  }

  Widget _buildStepControls() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0, right: 10.0),
      child: Column(
        children: [
          SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (_currentStep != 0)
                ElevatedButton(
                  onPressed: _currentStep > 0
                      ? () {
                    setState(() {
                      _currentStep--;
                    });
                  }
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Text(
                      'Précédent',
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
                onPressed: _currentStep < 2
                    ? () {
                  setState(() {
                    _currentStep++;
                  });
                }
                    : _showConfirmationDialog,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Text(
                    _currentStep == 2 ? 'Valider' : 'Suivant',
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
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Confirmation',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Vous êtes sûr d\'ajouter cette commande ?',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentStep = 0;
                });
              },
              child: Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addOrder();
              },
              child: Text(
                'Valider',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addOrder() async {
    final orderModel = Provider.of<OrderModel>(context, listen: false);
    final newOrder = Order(
      id: '', // Backend will assign ID
      site: _orderData['site'] as String,
      clientName: _orderData['client'] as String,
      dateCommande: _orderData['dateCommande'] as String,
      dateLivraison: _orderData['dateLivraison'] as String,
      articles: _orderData['articles'] as List<Article>,
      priority: _orderData['priority'] as Priority,
      etatCommande: Status.Encours,
      observation: _orderData['observation'] as String,
    );
    await orderModel.createOrder(newOrder);
    Navigator.pop(context);
  }
}
