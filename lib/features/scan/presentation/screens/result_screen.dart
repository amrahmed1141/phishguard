import 'package:flutter/material.dart';

import '../../data/scan_model.dart';
import '../widgets/confidence_bar.dart';
import '../widgets/risk_badge.dart';
import '../widgets/verdict_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.scanResult});

  final ScanModel scanResult;

  String get _verdictUpper => scanResult.verdict.toUpperCase();

  bool get _isSafe => _verdictUpper == 'SAFE';

  bool get _isPhishing => _verdictUpper == 'PHISHING';

  Color get _accent {
    if (_isSafe) return Colors.green;
    if (_isPhishing) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = _isSafe
        ? Colors.green.shade50
        : (_isPhishing ? Colors.red.shade50 : Colors.grey.shade100);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Scan Result'),
        backgroundColor: _accent.withOpacity(0.15),
        foregroundColor: theme.colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerdictCard(verdict: scanResult.verdict),
            const SizedBox(height: 16),
            ConfidenceBar(confidence: scanResult.confidence),
            const SizedBox(height: 16),
            RiskBadge(riskLevel: scanResult.riskLevel),
            const SizedBox(height: 24),
            Card(
              color: _accent.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scanned URL',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      scanResult.url,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Engine',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scanResult.engine.isEmpty ? '—' : scanResult.engine,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Signals',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (scanResult.signals.isEmpty)
              Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: theme.hintColor),
                  title: Text(
                    'No signals reported',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )
            else
              ...scanResult.signals.map(
                (signal) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.flag_outlined, color: _accent),
                      title: Text(signal),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scanned: ${scanResult.scannedAt.toLocal()}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
