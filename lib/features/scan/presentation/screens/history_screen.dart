import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/scan_cubit.dart';
import '../../cubit/scan_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScanCubit>().getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
      ),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            historyLoaded: (history) {
              if (history.isEmpty) {
                return const Center(child: Text('No scans yet'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final scan = history[index];
                  return Card(
                    child: ListTile(
                      title: Text(scan.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        'Result: ${scan.verdict.toUpperCase()} • Conf: ${(scan.confidence * 100).toStringAsFixed(1)}%',
                      ),
                      trailing: _getVerdictIcon(scan.verdict),
                      onTap: () {
                        // Logic to view details
                      },
                    ),
                  );
                },
              );
            },
            failure: (message) => Center(child: Text(message)),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _getVerdictIcon(String verdict) {
    switch (verdict.toUpperCase()) {
      case 'SAFE':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'SUSPICIOUS':
        return const Icon(Icons.warning, color: Colors.orange);
      case 'PHISHING':
      case 'DANGEROUS':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help_outline);
    }
  }
}
