import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:summerbody/main.dart';
import 'package:summerbody/services/DIService.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late DateTime currentDate;

  setUp(() {
    currentDate = DateTime.now();
  });

  String getDay(int value) {
    switch (value) {
      case 7:
        return "Sunday";
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "Sunday";
    }
  }

  group('End to End tests', () {
    setUpAll(() async {
      await DIService().setupLocator();
    });

    testWidgets('Load the current day', (tester) async {
      await tester.pumpWidget(ScreenUtilInit(
          designSize: const Size(448.0, 973.34),
          builder: (context, child) => const MyApp()));

      await tester.pumpAndSettle();

      final currentDayFinder = find.text(getDay(currentDate.weekday));

      expect(currentDayFinder, findsOneWidget);
    });
  });
}
