import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/order.dart';

class orderDetails extends StatelessWidget {
  final Order order;

  const orderDetails({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
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
              "Détails Commande",
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
              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade300,
                  ),
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info),
                          SizedBox(width: 8), // Space between icon and text
                          Text("Générale"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article),
                          SizedBox(width: 8), // Space between icon and text
                          Text("Articles"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14, width: 14),
              // Tab View
              Expanded(
                child: TabBarView(
                  children: [
                    // Général Tab
                    ListView(
                      children: [
                        _buildDetailRow("ID Commande", order.id),
                        _buildDetailRow("Etat commande", order.etatCommande),
                        _buildDetailRow("Site", order.site),
                        _buildDetailRow("Nom client", order.clientName),
                        _buildDateFields(order.dateCommande, order.dateLivraison),
                        _buildDetailRow("Priorité", describeEnum(order.priority)),
                        _buildDetailRow("Observation", order.observation),
                      ],
                    ),
                    // Lignes Tab
                    ListView.builder(
                      itemCount: order.articles.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          elevation: 4,
                          shadowColor: Colors.black45,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.articles[index].articleName, style: const TextStyle(fontSize: 16)),
                                Text(
                                  '${order.articles[index].quantity} ${order.articles[index].unit}',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(icon, size: 20, color: Colors.green),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: const TextStyle(fontSize: 14),
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

  Widget _buildDateFields(String dateCommande, String dateLivraison) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailRow("Date commande", dateCommande, icon: Icons.calendar_today),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDetailRow("Date livraison", dateLivraison, icon: Icons.calendar_today),
        ),
      ],
    );
  }

}
