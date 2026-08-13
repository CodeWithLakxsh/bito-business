import 'package:flutter_test/flutter_test.dart';

import 'package:biteo_business/main.dart';

void main() {
  testWidgets('Bito Business renders the admin access screen',
      (WidgetTester tester) async {
    // Build the app. Firebase initialization happens in main(), not in
    // MyApp, so this smoke test runs without a Firebase configuration.
    await tester.pumpWidget(const MyApp());

    // The entry gate (AuthScreen) must be visible.
    expect(find.text('Biteo Secure Access'), findsOneWidget);

    // The authenticator input must be present.
    expect(find.text('Authenticator Code'), findsOneWidget);

    // The verify action must be present.
    expect(find.text('Verify & Continue'), findsOneWidget);
  });
}
