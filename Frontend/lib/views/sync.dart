import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orderProvider.dart';
import '../views/orderDetails.dart';
import 'package:flutter/scheduler.dart';

class Synchronisation extends StatelessWidget {
  const Synchronisation({super.key});

  @override
  Widget build(BuildContext context) {
    // Defer fetchLocalOrders until after the initial build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final orderModel = Provider.of<OrderModel>(context, listen: false);
      orderModel.fetchLocalOrders();
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            "Synchronisation",
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
        child: Column(
          children: [
            Expanded(
              child: Consumer<OrderModel>(
                builder: (context, orderModel, _) {
                  if (orderModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (orderModel.orders.isEmpty) {
                    return const Center(child: Text('Aucune commande à synchroniser n`est trouvée'));
                  } else {
                    return ListView.builder(
                      itemCount: orderModel.orders.length,
                      itemBuilder: (context, index) {
                        final order = orderModel.orders[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(order.id),
                              subtitle: Text(order.clientName),
                              trailing: Text(
                                '${order.articles.length} articles',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => orderDetails(order: order),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0, top: 14.0),
              child: ElevatedButton(
                onPressed: () async {
                  final orderModel = Provider.of<OrderModel>(context, listen: false);
                  await orderModel.synchronizeLocalOrders(context);
                  // Fetch local orders again to update the UI
                  await orderModel.fetchLocalOrders();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  child: Text(
                    'Synchroniser',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
