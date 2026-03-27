import 'package:flutter_test/flutter_test.dart';

import 'package:phishguard/core/network/dio_client.dart';
import 'package:phishguard/features/scan/data/scan_api_service.dart';
import 'package:phishguard/main.dart';

void main() {
  testWidgets('PhishGuard home shows app title and scan action', (
    WidgetTester tester,
  ) async {
    final scanApiService = ScanApiService(DioClient());
    await tester.pumpWidget(PhishGuardApp(scanApiService: scanApiService));

    expect(find.text('PhishGuard'), findsOneWidget);
    expect(find.textContaining('Check a link'), findsOneWidget);
    expect(find.text('Scan URL'), findsOneWidget);
  });
}
