import 'package:flutter/material.dart';
import '../../data/scan_model.dart';
import '../widgets/verdict_card.dart';
import '../widgets/confidence_bar.dart';
import '../widgets/risk_badge.dart';

class ResultScreen extends StatelessWidget {
  final ScanModel scanResult;

  const ResultScreen({super.key, required this.scanResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scanned URL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scanResult.url,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (scanResult.threats.isNotEmpty) ...[
              const Text(
                'Detected Threats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...scanResult.threats.map((threat) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.orange),
                      title: Text(threat),
                    ),
                  )),
            ],
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scan Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('ID: ${scanResult.id}'),
                    Text('Scanned: ${scanResult.scannedAt.toString()}'),
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
