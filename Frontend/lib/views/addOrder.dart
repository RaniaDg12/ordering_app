import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:provider/provider.dart';
import '../providers/orderProvider.dart';
import '../providers/OrderStepProvider.dart';
import '../models/enums/priority.dart';
import '../models/order.dart';
import '../models/article.dart';
import 'clientStep.dart';
import 'articlesStep.dart';
import 'autresStep.dart';

class AddOrder extends StatelessWidget {
  const AddOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderModel()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = OrderStepProvider();
            provider.setCurrentStep(0); // Ensure to start at the Client step
            provider.resetOrderData(); // Reset the order data
            return provider;
          },
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                // Dispose of the provider when navigating away
                context.read<OrderStepProvider>().resetOrderData();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: const Text(
              "Nouvelle commande",
              style: TextStyle(color: Colors.white),
            ),
            flexibleSpace: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<OrderStepProvider>(
            builder: (context, StepProvider, _) => Column(
              children: [
                EasyStepper(
                  activeStep: StepProvider.currentStep,
                  stepShape: StepShape.circle,
                  stepRadius: 32,
                  finishedStepBorderColor: Colors.green,
                  finishedStepTextColor: Colors.green,
                  finishedStepBackgroundColor: Colors.green,
                  activeStepIconColor: Colors.green,
                  showLoadingAnimation: false,
                  steps: const [
                    EasyStep(
                      icon: Icon(Icons.person),
                      customTitle: Text(
                        'Client',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                    EasyStep(
                      icon: Icon(Icons.article),
                      customTitle: Text(
                        'Articles',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                    EasyStep(
                      icon: Icon(Icons.more_horiz),
                      customTitle: Text(
                        'Autres',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                  ],
                  onStepReached: (index) {
                    StepProvider.setCurrentStep(index);
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
    return Consumer<OrderStepProvider>(
      builder: (context, StepProvider, child) {
        switch (StepProvider.currentStep) {
          case 0:
            return ClientStep(
              orderData: StepProvider.orderData,
              onUpdate: (key, value) {
                StepProvider.updateOrderData(key, value);
              },
            );
          case 1:
            return ArticlesStep(
              orderData: StepProvider.orderData,
              onUpdate: (key, value) {
                StepProvider.updateOrderData(key, value);
              },
            );
          case 2:
            return AutresStep(
              orderData: StepProvider.orderData,
              onUpdate: (key, value) {
                StepProvider.updateOrderData(key, value);
              },
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildStepControls() {
    return Consumer<OrderStepProvider>(
      builder: (context, StepProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 10.0),
          child: Column(
            children: [
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (StepProvider.currentStep != 0)
                    ElevatedButton(
                      onPressed: StepProvider.currentStep > 0
                          ? () {
                        StepProvider.decrementStep();
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Text(
                          'Précédent',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: StepProvider.currentStep < 2
                        ? () {
                      StepProvider.incrementStep();
                    }
                        : () {
                      _showConfirmationDialog(context, StepProvider.orderData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        StepProvider.currentStep == 2 ? 'Valider' : 'Suivant',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
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
          title: const Text('Confirmation', style: TextStyle(color: Colors.green)),
          content: const Text('Êtes-vous sûr de valider la commande?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<OrderStepProvider>().setCurrentStep(0);
              },
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
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
                  etatCommande: "Encours",
                  observation: orderData['observation'] as String,
                );
                print('Order final: $order');

                await context.read<OrderModel>().addOrder(order);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Succès', style: TextStyle(color: Colors.green)),
                      content: const Text('Commande passée avec succès!', style: TextStyle(color: Colors.black)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil('/orderlist', (Route<dynamic> route) => false);
                          },
                          child: const Text('OK', style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Valider', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}

