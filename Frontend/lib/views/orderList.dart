import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/orderList.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SizedBox(
            width: 120,
            height: 60,
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
        ),
        title: Text(
          "Liste Commande",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: Icon(Icons.logout, color: Colors.green),
          ),
        ],
      ),
      body: Consumer<OrderModel>(
        builder: (context, orderModel, _) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher",
                  prefixIcon: Icon(Icons.search, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Filter logic
                  },
                  child: Text("Tous"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Filter logic
                  },
                  child: Text("Terminé"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Filter logic
                  },
                  child: Text("En cours"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: orderModel.orders.map((order) {
                    return OrderCard(
                      order: order,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12.0,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, size: 32),
                onPressed: () {
                  Navigator.pushNamed(context, '/orderlist');
                },
              ),
              SizedBox(width: 48), // Space for the FloatingActionButton
              IconButton(
                icon: Icon(Icons.sync, size: 32),
                onPressed: () {
                  Navigator.pushNamed(context, '/sync');
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 75.0,
        height: 75.0,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          shape: CircleBorder(),
          hoverElevation: 10,
          splashColor: Colors.green,
          elevation: 4,
          child: Icon(Icons.add, size: 32), // Increased icon size inside FAB
          onPressed: () {
            Navigator.pushNamed(context, '/addOrder');
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.orderId,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("Client name: ${order.clientName}"),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 8),
                Text(order.date),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${order.articlesCount} articles",
                  style: TextStyle(
                    color: order.articlesCount == 2
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
