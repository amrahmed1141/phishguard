import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../cubit/scan_cubit.dart';
import '../../cubit/scan_state.dart';
import '../widgets/phishguard_logo.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
              'Scan History',
              style: theme.appBarTheme.titleTextStyle ?? theme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading history…',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            historyLoaded: (history) {
              if (history.isEmpty) {
                return _HistoryEmptyState(theme: theme, colorScheme: colorScheme);
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final scan = history[index];
                  return _HistoryListTile(
                    url: scan.url,
                    verdict: scan.verdict,
                    confidence: scan.confidence,
                    scannedAt: scan.scannedAt,
                    theme: theme,
                    colorScheme: colorScheme,
                    onTap: () {
                      // Logic to view details
                    },
                  );
                },
              );
            },
            failure: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                ),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState({required this.theme, required this.colorScheme});

  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withOpacity(0.45),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.25),
                ),
              ),
              child: PhishGuardLogo(
                size: 56,
                strokeColor: colorScheme.primary,
                strokeWidth: 2.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No scans yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'URLs you scan will appear here so you can review past verdicts anytime.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryListTile extends StatelessWidget {
  const _HistoryListTile({
    required this.url,
    required this.verdict,
    required this.confidence,
    required this.scannedAt,
    required this.theme,
    required this.colorScheme,
    required this.onTap,
  });

  final String url;
  final String verdict;
  final double confidence;
  final DateTime scannedAt;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stamp = _formatTimestamp(scannedAt);

    return Material(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShapes.radiusMd),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.22)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      url,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _VerdictPill(verdict: verdict),
                        const SizedBox(width: 10),
                        Text(
                          '${(confidence * 100).toStringAsFixed(1)}% conf.',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          stamp,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _VerdictTrailingIcon(verdict: verdict),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final local = dt.toLocal();
    final d =
        '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    final t =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    return '$d · $t';
  }
}

class _VerdictPill extends StatelessWidget {
  const _VerdictPill({required this.verdict});

  final String verdict;

  @override
  Widget build(BuildContext context) {
    final v = verdict.toUpperCase();
    late final Color fg;
    late final Color bg;
    switch (v) {
      case 'SAFE':
        fg = Colors.green.shade800;
        bg = Colors.green.shade50;
        break;
      case 'SUSPICIOUS':
        fg = Colors.orange.shade900;
        bg = Colors.orange.shade50;
        break;
      case 'PHISHING':
      case 'DANGEROUS':
        fg = Colors.red.shade900;
        bg = Colors.red.shade50;
        break;
      default:
        fg = Colors.blueGrey.shade800;
        bg = Colors.blueGrey.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Text(
        v,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
      ),
    );
  }
}

class _VerdictTrailingIcon extends StatelessWidget {
  const _VerdictTrailingIcon({required this.verdict});

  final String verdict;

  @override
  Widget build(BuildContext context) {
    switch (verdict.toUpperCase()) {
      case 'SAFE':
        return Icon(Icons.verified_rounded, color: Colors.green.shade600, size: 28);
      case 'SUSPICIOUS':
        return Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 28);
      case 'PHISHING':
      case 'DANGEROUS':
        return Icon(Icons.gpp_bad_rounded, color: Colors.red.shade600, size: 28);
      default:
        return Icon(Icons.help_outline_rounded, color: Theme.of(context).hintColor, size: 26);
    }
  }
}
