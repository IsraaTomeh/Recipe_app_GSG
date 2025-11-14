import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget {
  const IngredientItem({super.key, required this.name, required this.quantity});
  final String name;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(color: Color.fromARGB(255, 47, 155, 99)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 16))),
          Text("x$quantity"),
        ],
      ),
    );
  }
}
