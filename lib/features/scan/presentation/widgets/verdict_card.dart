import 'package:flutter/material.dart';

class VerdictCard extends StatelessWidget {
  final String verdict;

  const VerdictCard({super.key, required this.verdict});

  Color _getVerdictColor() {
    switch (verdict.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'suspicious':
        return Colors.orange;
      case 'dangerous':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getVerdictIcon() {
    switch (verdict.toLowerCase()) {
      case 'safe':
        return Icons.check_circle;
      case 'suspicious':
        return Icons.warning;
      case 'dangerous':
        return Icons.dangerous;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getVerdictColor().withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _getVerdictIcon(),
              size: 48,
              color: _getVerdictColor(),
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
                    verdict,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getVerdictColor(),
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
