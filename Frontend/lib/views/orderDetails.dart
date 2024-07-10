import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/order.dart';

class orderDetails extends StatelessWidget {
  final Order order;

  const orderDetails({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Détails Commande"),
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
              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: TabBar(
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.green,
                  tabs: const [
                    Tab(text: "Générale"),
                    Tab(text: "Articles"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Tab View
              Expanded(
                child: TabBarView(
                  children: [
                    // Général Tab
                    ListView(
                      children: [
                        _buildDetailRow("ID Commande", order.id),
                        _buildDetailRow("Etat commande", describeEnum(order.etatCommande)),
                        _buildDetailRow("Site", order.site),
                        _buildDetailRow("Nom client", order.clientName),
                        _buildDetailRow("Date commande", order.dateCommande,
                            icon: Icons.calendar_today),
                        _buildDetailRow("Date livraison", order.dateLivraison,
                            icon: Icons.calendar_today),
                        _buildDetailRow("Priorité", describeEnum(order.priority)),
                        _buildDetailRow("Observation", order.observation),
                        // Save Button
                      ],
                    ),
                    // Lignes Tab
                    ListView.builder(
                      itemCount: order.articles.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.articles[index].articleName),
                                Text(
                                  '${order.articles[index].quantity} ${order.articles[index].unit}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    bool isDateField = label == "Date commande" || label == "Date livraison";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (isDateField && icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(icon, size: 20),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          value,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
