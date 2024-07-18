import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../views/orderDetails.dart';

class Synchronisation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            "Synchronisation",
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.only(
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
        child: ChangeNotifierProvider(
          key: Key('orderModel'),
          create: (_) => OrderModel()..fetchLocalOrders(),
          child: Column(
            children: [
              Expanded(
                child: Consumer<OrderModel>(
                  builder: (context, orderModel, _) => ListView.builder(
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
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0, top: 14.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final orderModel = Provider.of<OrderModel>(context, listen: false);
                    await orderModel.synchronizeLocalOrders(context);
                    await orderModel.fetchLocalOrders();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                    child: Text(
                      'Synchroniser',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
