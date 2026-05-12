import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/scan_model.dart';
import '../widgets/confidence_bar.dart';
import '../widgets/phishguard_logo.dart';
import '../widgets/risk_badge.dart';
import '../widgets/verdict_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.scanResult});

  final ScanModel scanResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhishGuardLogo(
              size: 26,
              strokeColor: theme.appBarTheme.foregroundColor ?? Colors.white,
              strokeWidth: 2,
            ),
            const SizedBox(width: 8),
            Text(
              'Scan Result',
              style: theme.appBarTheme.titleTextStyle ??
                  theme.textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerdictCard(verdict: scanResult.verdict),
            const SizedBox(height: 16),
            ConfidenceBar(confidence: scanResult.confidence),
            const SizedBox(height: 14),
            RiskBadge(riskLevel: scanResult.riskLevel),
            const SizedBox(height: 22),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.link_rounded,
                    label: 'Scanned URL',
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    scanResult.url,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.memory_rounded,
                    label: 'Engine',
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scanResult.engine.isEmpty ? '—' : scanResult.engine,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Signals',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            if (scanResult.signals.isEmpty)
              _SectionCard(
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No signals reported',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...scanResult.signals.map(
                (signal) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SectionCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.flag_rounded, color: colorScheme.primary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Text(signal, style: theme.textTheme.bodyLarge)),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.schedule_rounded,
                    label: 'Scan details',
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scanned: ${scanResult.scannedAt.toLocal()}',
                    style: theme.textTheme.bodyMedium,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShapes.radiusMd),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
