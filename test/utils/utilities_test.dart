import 'package:flutter_test/flutter_test.dart';
import 'package:summerbody/utils/utilities.dart';

void main() {
  group('all utilities methods', () {
    test('date parser', () {
      DateTime date = DateTime(2025, 5, 9);

      Map<String, dynamic> parsedDate =
          Utilities.parseDate(date.toIso8601String());

      expect(parsedDate, {'date': '9', 'month': 'May'});
    });

    test('date to string', () {
      DateTime date = DateTime(2025, 5, 9);

      String dateString = Utilities.dateToString(date);
      expect(dateString, '9 May, 2025');
    });
  });
}
