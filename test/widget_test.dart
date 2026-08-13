import 'package:flutter_test/flutter_test.dart';

import 'package:biteo_business/main.dart';

void main() {
  testWidgets('Bito Business renders the admin access screen',
      (WidgetTester tester) async {
    // Use a phone-sized portrait viewport so the AuthScreen content does not
    // overflow the small default test surface (800x600).
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

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
