import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/scan_cubit.dart';
import '../../cubit/scan_state.dart';
import 'history_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter a URL to scan';
    final uri = Uri.tryParse(v);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Enter a valid URL (e.g. https://example.com)';
    }
    return null;
  }

  void _onScan(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ScanCubit>().scanUrl(_urlController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ScanCubit, ScanState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (result) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ResultScreen(scanResult: result)),
            );
            // Reset state so we don't navigate again on rebuild
            context.read<ScanCubit>().reset();
          },
          failure: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
              ),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PhishGuard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Icon(Icons.shield_outlined, size: 56, color: colorScheme.primary),
                  const SizedBox(height: 20),
                  Text(
                    'Check a link before you open it',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'URL',
                      hintText: 'https://example.com/page',
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: _validateUrl,
                    onFieldSubmitted: (_) => _onScan(context),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<ScanCubit, ScanState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
                      return FilledButton.icon(
                        onPressed: isLoading ? null : () => _onScan(context),
                        icon: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(isLoading ? 'Scanning…' : 'Scan URL'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildTipCard(theme, colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: colorScheme.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tip: Use a full URL with a scheme (https://…). The scan runs against the configured PhishGuard backend.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
