import 'package:flutter/material.dart';

class VerdictCard extends StatelessWidget {
  final String verdict;

  const VerdictCard({super.key, required this.verdict});

  Color _getVerdictColor() {
    switch (verdict.toUpperCase()) {
      case 'SAFE':
        return Colors.green;
      case 'SUSPICIOUS':
        return Colors.orange;
      case 'PHISHING':
      case 'DANGEROUS':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getVerdictIcon() {
    switch (verdict.toUpperCase()) {
      case 'SAFE':
        return Icons.check_circle;
      case 'SUSPICIOUS':
        return Icons.warning;
      case 'PHISHING':
      case 'DANGEROUS':
        return Icons.dangerous;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getVerdictColor();
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _getVerdictIcon(),
              size: 48,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verdict',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    verdict.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
