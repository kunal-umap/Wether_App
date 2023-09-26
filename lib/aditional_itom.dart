import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Text(
            label,
            style:const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16
            ),
            textAlign: TextAlign.left,
          ),Text(
            value,
            style:const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
