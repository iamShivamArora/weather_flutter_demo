import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:open_weather_demo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Test', () {
    testWidgets('Splash to Home with Weather Report',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(); // Wait for app to initialize

      expect(find.text('Welcome to WeatherApp'),
          findsOneWidget); // Replace with actual splash screen identifier
    });
  });
}
