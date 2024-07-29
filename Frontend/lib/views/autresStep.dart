import 'package:flutter/material.dart';
import '../models/enums/priority.dart';

class AutresStep extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final Function(String, dynamic) onUpdate;

  final List<String> priorities = ['Faible', 'Moyenne', 'Eleve'];

  AutresStep({super.key, required this.orderData, required this.onUpdate});

  @override
  Widget build(BuildContext context) {

    print('Current Order Data in autreStep: $orderData');

    return Column(
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
        child:
         DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Choisir priorité commande',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          items: priorities.map((priority) {
            return DropdownMenuItem(value: priority, child: Text(priority));
          }).toList(),
          onChanged: (value) {
            orderData['priority'] = _getPriorityEnum(value!);
            onUpdate('priority', _getPriorityEnum(value));
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
          child:
         TextField(
          decoration: InputDecoration(
            labelText: 'Observation',
            filled: true,
            fillColor: Colors.grey.shade100,
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
