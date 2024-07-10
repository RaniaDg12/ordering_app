import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../views/orderDetails.dart';

class Synchronisation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Synchronisation'),
        backgroundColor: Colors.green,
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
            Consumer<OrderModel>(
              builder: (context, orderModel, _) => Expanded(
                child: ListView.builder(
                  itemCount: orderModel.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderModel.orders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(order.id),
                          subtitle: Text(order.clientName),
                          trailing: Text('${order.articles.length} articles'),
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
            const Spacer(),
            ElevatedButton(
              onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
