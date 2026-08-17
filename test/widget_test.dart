import 'package:flutter_test/flutter_test.dart';
import 'package:note_alarm/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app builds and shows the home shell', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const NoteAlarmApp());
    await tester.pump();

    expect(find.text('Alarms'), findsWidgets);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('No alarms set'), findsOneWidget);
  });
}
