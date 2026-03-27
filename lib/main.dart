import 'package:flutter/material.dart';

import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'features/scan/data/scan_api_service.dart';
import 'features/scan/presentation/screens/home_screen.dart';

void main() {
  final dioClient = DioClient();
  final scanApiService = ScanApiService(dioClient);
  runApp(PhishGuardApp(scanApiService: scanApiService));
}

class PhishGuardApp extends StatelessWidget {
  const PhishGuardApp({super.key, required this.scanApiService});

  final ScanApiService scanApiService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhishGuard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomeScreen(scanApiService: scanApiService),
    );
  }
}
