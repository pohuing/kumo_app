import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kumo_app/widgets/explorer/nested_explorer.dart';

import '../../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('log-in test', () {
    testWidgets('verify log in behaviour', (widgetTester) async {
      await app.main(runningAsTest: true);
      await widgetTester.pumpAndSettle();
      expect(find.byKey(const Key('email')), findsOneWidget);
      await widgetTester.enterText(
        find.byKey(const Key('email')),
        'admin@mail.com',
      );
      await widgetTester.enterText(
        find.byKey(const Key('password')),
        'admin123',
      );
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('log_in_button')));

      await widgetTester.pumpAndSettle();

      expect(find.byType(NestedExplorer), findsOneWidget);
    });
  });
}
