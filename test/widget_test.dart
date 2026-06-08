import 'package:flutter_test/flutter_test.dart';
import 'package:gitakshmi_hrms_app/app/app.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the initialization text is present
    expect(find.text('Gitakshmi HRMS'), findsOneWidget);

    // Advance virtual clock by 2 seconds to let SplashPage timer fire and navigate
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
