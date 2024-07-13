import 'package:flutter/material.dart';
import '../models/order.dart';

class AutresStep extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final Function(String, dynamic) onUpdate;

  final List<String> priorities = ['Faible', 'Moyenne', 'Eleve'];

  AutresStep({required this.orderData, required this.onUpdate});

  @override
  Widget build(BuildContext context) {

    print('Current Order Data in autreStep: $orderData');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Choisir priorité commande',
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          items: priorities.map((priority) {
            return DropdownMenuItem(child: Text(priority), value: priority);
          }).toList(),
          onChanged: (value) {
            orderData['priority'] = _getPriorityEnum(value!);
            onUpdate('priority', _getPriorityEnum(value));
          },
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Observation',
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            orderData['observation'] = value;
            onUpdate('observation', value);
          },
        ),
      ],
    );
  }

  Priority _getPriorityEnum(String value) {
    switch (value) {
      case 'Faible':
        return Priority.Faible;
      case 'Moyenne':
        return Priority.Moyenne;
      case 'Eleve':
        return Priority.Eleve;
      default:
        return Priority.Faible;
    }
  }
}
