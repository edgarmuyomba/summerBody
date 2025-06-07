import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:summerbody/widgets/workoutWidget.dart';

void main() {
  late Map<String, dynamic> workout;

  setUp(() {
    workout = {
      "id": 1,
      "name": "Bench press",
      "sets": [
        {
          "weight1": 20.0,
          "reps1": 75,
          "weight2": 17.5,
          "reps2": 25,
          "date": DateTime(2025, 5, 9).toString()
        }
      ]
    };
  });

  group('Workout Widget variations', () {
    testWidgets('Name and date clear', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context,
                  designSize: const Size(448, 973.34),
                  minTextAdapt: true,
                  splitScreenMode: false);
              return Scaffold(
                body: WorkoutWidget(
                  workout: workout,
                ),
              );
            },
          ),
        ),
      );

      final workoutNameFinder = find.text("Bench press");
      final formattedDateFinder = find.text('9');
      final formattedMonthFinder = find.text('May');

      expect(workoutNameFinder, findsOneWidget);
      expect(formattedDateFinder, findsOneWidget);
      expect(formattedMonthFinder, findsOneWidget);
    });

    testWidgets('Workout Widget can delete', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context,
                  designSize: const Size(448, 973.34),
                  minTextAdapt: true,
                  splitScreenMode: false);
              return Scaffold(
                body: WorkoutWidget(
                  workout: workout,
                  canDelete: true,
                ),
              );
            },
          ),
        ),
      );

      final deleteIconFinder = find.byType(IconButton);

      expect(deleteIconFinder, findsOneWidget);
    });

    testWidgets('Workout Widget cannot delete', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context,
                  designSize: const Size(448, 973.34),
                  minTextAdapt: true,
                  splitScreenMode: false);
              return Scaffold(
                body: WorkoutWidget(
                  workout: workout,
                ),
              );
            },
          ),
        ),
      );

      final deleteIconFinder = find.byType(IconButton);

      expect(deleteIconFinder, findsNothing);
    });
  });
}
