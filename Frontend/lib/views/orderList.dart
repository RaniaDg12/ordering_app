import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../views/orderDetails.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SizedBox(
            width: 140,
            height: 100,
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              icon: Icon(Icons.logout, color: Colors.green),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow
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
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Rechercher",
                      prefixIcon: Icon(Icons.search, color: Colors.green),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          orderModel.fetchOrders();
                        },
                      )
                          : IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        await orderModel.fetchOrderById(value.trim());
                      } else {
                        orderModel.fetchOrders();
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await orderModel.fetchOrders();
                      },
                      child: Text(
                        "Tous",
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await orderModel.fetchByStatus('Termine');
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
                        await orderModel.fetchByStatus('Encours');
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
                  Center(child: Text('Aucune commande trouvée.'))
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: orderModel.orders.map((order) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: OrderCard(order: order),
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
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        child:
        BottomAppBar(
          child: Container(
            height: 16.0,
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
       ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 85.0,
        height: 85.0,
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
                SizedBox(height: 10), // Increased spacing
                Text("Client: ${order.clientName}"),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text(
                      "${order.dateCommande}",
                    ),
                    SizedBox(width: 16), // Added spacing between date and site
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* class FilterDialog extends StatelessWidget {
  final TextEditingController clientController = TextEditingController();
  final TextEditingController siteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filtrer la recherche', style: TextStyle(color: Colors.black)),
      content: Row(
        children: [
       Expanded(
         child: TextField(
           controller: clientController,
            decoration: InputDecoration(
              labelText: 'Client',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(20),
               borderSide: BorderSide.none,
             ),
            ),
          ),
       ),
          SizedBox(width: 16),
       Expanded(
        child: TextField(
          controller: siteController,
            decoration: InputDecoration(
              labelText: 'Site',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
       ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () async {
            String client = clientController.text.trim();
            String site = siteController.text.trim();
            if (client.isNotEmpty) {}
            if (site.isNotEmpty) {}

            Navigator.of(context).pop();
          },
          child: Text('Apply', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}*/