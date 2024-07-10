import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../views/orderDetails.dart';

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
            height: 80,
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
        ),
        title: Text(
          "Liste Commande",
          style: TextStyle(
            fontSize: 22.0,
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
      body: ChangeNotifierProvider<OrderModel>(
        create: (_) => OrderModel()..fetchOrders(),
        child: Consumer<OrderModel>(
          builder: (context, orderModel, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Rechercher",
                      prefixIcon: Icon(Icons.search, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await orderModel.fetchOrders(); // Fetch all orders
                      },
                      child: Text(
                        "Tous",
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await orderModel.fetchByStatus('Termine'); // Fetch orders by status 'Terminé'
                      },
                      child: Text(
                        "Terminé",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await orderModel.fetchByStatus('Encours'); // Fetch orders by status 'En cours'
                      },
                      child: Text(
                        "En cours",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (orderModel.isLoading)
                  Center(child: CircularProgressIndicator())
                else if (orderModel.orders.isEmpty) // Show this only if orders list is empty
                  Center(child: Text('No orders found.'))
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: orderModel.orders.map((order) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: OrderCard(
                              order: order,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12.0,
        child: Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, size: 32),
                onPressed: () {
                  Navigator.pushNamed(context, '/orderlist');
                },
              ),
              SizedBox(width: 48),
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
          child: Icon(Icons.add, size: 32),
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
    Color lineColor = order.etatCommande == Status.Termine ? Colors.green : Colors.orange;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => orderDetails(order: order),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: lineColor,
                width: 5,
              ),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.id,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8), // Add some spacing between the two texts
                    Text(
                      "${order.articles.length} articles",
                      style: TextStyle(
                        color: lineColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text("Client: ${order.clientName}"),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            "${order.dateCommande}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${order.site}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}