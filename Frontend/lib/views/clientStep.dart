import 'package:flutter/material.dart';
import '../models/order.dart';

class ClientStep extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final Function(String, dynamic) onUpdate;

  ClientStep({required this.orderData, required this.onUpdate});

  final List<String> sites = ['AGAREB', 'CAPBON'];
  final List<String> clients = ['Ahmed', 'Sami', 'Fawzi'];


  final TextEditingController dateCommandeController = TextEditingController();
  final TextEditingController dateLivraisonController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    print('Current Order Data in ClientStep: $orderData');

    dateCommandeController.text = orderData['dateCommande'] ?? '';
    dateLivraisonController.text = orderData['dateLivraison'] ?? '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Choisir un site',
              prefixIcon: Icon(Icons.location_on),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: sites.map((site) {
              return DropdownMenuItem(child: Text(site), value: site);
            }).toList(),
            onChanged: (value) {
              print('Selected site: $value');
              orderData['site'] = value!;
              onUpdate('site', value);
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Choisir un client',
              prefixIcon: Icon(Icons.person),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: clients.map((client) {
              return DropdownMenuItem(child: Text(client), value: client);
            }).toList(),
            onChanged: (value) {
              print('Selected client: $value');
              orderData['client'] = value!;
              onUpdate('client', value);
            },
          ),
          SizedBox(height: 16),
          TextField(
            controller: dateCommandeController,
            decoration: InputDecoration(
              labelText: 'Date de Commande',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            readOnly: true,
            onTap: () {
              _selectDate(context, 'dateCommande', dateCommandeController);
            },
          ),
          SizedBox(height: 16),
          TextField(
            controller: dateLivraisonController,
            decoration: InputDecoration(
              labelText: 'Date de Livraison',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            readOnly: true,
            onTap: () {
              _selectDate(context, 'dateLivraison', dateLivraisonController,);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String field, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black45, // Body text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formattedDate = "${picked.year}-${picked.month}-${picked.day}"; // Format as needed
      orderData[field] = formattedDate;
      controller.text = formattedDate;
      print('Selected date: $formattedDate');
      onUpdate(field, formattedDate);
    }
  }
}
