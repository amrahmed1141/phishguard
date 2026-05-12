import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class RiskBadge extends StatelessWidget {
  final String riskLevel;

  const RiskBadge({super.key, required this.riskLevel});

  Color _getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green.shade700;
      case 'medium':
        return Colors.orange.shade800;
      case 'high':
        return Colors.red.shade700;
      case 'critical':
        return Colors.deepPurple.shade700;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  IconData _getRiskIcon() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Icons.verified_user_outlined;
      case 'medium':
        return Icons.warning_amber_rounded;
      case 'high':
        return Icons.error_outline_rounded;
      case 'critical':
        return Icons.dangerous_outlined;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getRiskColor();

    return Material(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShapes.radiusSm),
        side: BorderSide(color: color.withOpacity(0.45)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getRiskIcon(),
                size: 18,
                color: color,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Risk level',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  riskLevel.toUpperCase(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
