import 'package:flutter/material.dart';


class ForcastCard extends StatelessWidget {
  final String time;
  final String value;
  final IconData icon;

  const ForcastCard({
    super.key,
    required this.time,
    required this.value,
    this.icon = Icons.cloud
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 8,
      child: Padding(
        padding:const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              time,
              style:const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18
              ),
            ),
            const SizedBox(height: 8),
            Icon(
                icon,
              size: 32,
            ),
            Text(
              value,
              style:const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12
              ),
            ),
          ],
        ),
      ),
    );
  }
}
