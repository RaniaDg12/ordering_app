import 'package:flutter/material.dart';

class ClientStep extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final Function(String, dynamic) onUpdate;

  ClientStep({super.key, required this.orderData, required this.onUpdate});

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
          Container(
            decoration: BoxDecoration(
             boxShadow: [
               BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
    ),
    ],
    ),
           child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Choisir un site',
              prefixIcon: const Icon(Icons.location_on),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: sites.map((site) {
              return DropdownMenuItem(value: site, child: Text(site));
            }).toList(),
            onChanged: (value) {
              print('Selected site: $value');
              orderData['site'] = value!;
              onUpdate('site', value);
            },
          ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
    ),
    ],
    ),
           child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Choisir un client',
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: clients.map((client) {
              return DropdownMenuItem(value: client, child: Text(client));
            }).toList(),
            onChanged: (value) {
              print('Selected client: $value');
              orderData['client'] = value!;
              onUpdate('client', value);
            },
          ),
    ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          child:
           TextField(
            controller: dateCommandeController,
            decoration: InputDecoration(
              labelText: 'Date de Commande',
              filled: true,
              fillColor: Colors.grey.shade100,
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
    ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                   color: Colors.grey.withOpacity(0.2),
                   spreadRadius: 2,
                   blurRadius: 5,
                   offset: const Offset(0, 3), // changes position of shadow
    ),
    ],
    ),
           child:
           TextField(
            controller: dateLivraisonController,
            decoration: InputDecoration(
              labelText: 'Date de Livraison',
              filled: true,
              fillColor: Colors.grey.shade100,
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
            colorScheme: const ColorScheme.light(
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
