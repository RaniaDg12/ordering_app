import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import 'clientStep.dart';
import 'articlesStep.dart';
import 'autresStep.dart';

class AddOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderModel(),
      child: Scaffold(
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
          child: Consumer<OrderModel>(
            builder: (context, orderModel, _) => Column(
              children: [
                EasyStepper(
                  activeStep: orderModel.currentStep,
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
                    orderModel.setCurrentStep(index);
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
        ),
      ),
    );
  }

  Widget _getStepContent() {
    return Consumer<OrderModel>(
      builder: (context, orderModel, child) {
        switch (orderModel.currentStep) {
          case 0:
            return ClientStep(
              orderData: orderModel.orderData,
              onUpdate: (key, value) {
                orderModel.updateOrderData(key, value);
              },
            );
          case 1:
            return ArticlesStep(
              orderData: orderModel.orderData,
              onUpdate: (key, value) {
                orderModel.updateOrderData(key, value);
              },
            );
          case 2:
            return AutresStep(
              orderData: orderModel.orderData,
              onUpdate: (key, value) {
                orderModel.updateOrderData(key, value);
              },
            );
          default:
            return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildStepControls() {
    return Consumer<OrderModel>(
      builder: (context, orderModel, child) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20.0, right: 10.0),
          child: Column(
            children: [
              SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (orderModel.currentStep != 0)
                    ElevatedButton(
                      onPressed: orderModel.currentStep > 0
                          ? () {
                        orderModel.decrementStep();
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
                    onPressed: orderModel.currentStep < 2
                        ? () {
                      orderModel.incrementStep();
                    }
                        : () {
                      _showConfirmationDialog(context, orderModel.orderData);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        orderModel.currentStep == 2 ? 'Valider' : 'Suivant',
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
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation', style: TextStyle(color: Colors.green)),
          content: Text('Êtes-vous sûr de valider la commande?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<OrderModel>().setCurrentStep(0);
              },
              child: Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                List<Article> articles = (orderData['articles'] as List<dynamic>).map((item) => Article(
                  id: '', // Ensure to assign proper IDs if necessary
                  articleName: item.articleName, // Access articleName directly
                  quantity: item.quantity, // Access quantity directly
                  unit: item.unit, // Access unit directly
                )).toList();

                final order = Order(
                  id: '', // Backend will assign ID
                  site: orderData['site'] as String,
                  clientName: orderData['client'] as String,
                  dateCommande: orderData['dateCommande'] as String,
                  dateLivraison: orderData['dateLivraison'] as String,
                  articles: articles,
                  priority: orderData['priority'] as Priority,
                  etatCommande: Status.Encours,
                  observation: orderData['observation'] as String,
                );
                print('Order final: $order');

                await context.read<OrderModel>().addOrder(order);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Succès', style: TextStyle(color: Colors.green)),
                      content: Text('Commande passée avec succès!', style: TextStyle(color: Colors.black)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil('/orderlist', (Route<dynamic> route) => false);
                          },
                          child: Text('OK', style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Valider', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
