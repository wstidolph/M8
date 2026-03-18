import 'package:flutter_test/flutter_test.dart';
import 'package:m8_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('M8 App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: M8App()));

    // Verify that the initial greeting is displayed
    expect(find.text('Ask a Question'), findsOneWidget);

    // Verify the shake button exists
    expect(find.text('Shake Device'), findsOneWidget);
  });
}
