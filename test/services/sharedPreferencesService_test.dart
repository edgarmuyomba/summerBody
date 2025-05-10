import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';

void main() {
  late SharedPreferencesService prefsService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    prefsService = SharedPreferencesService();
  });

  group('test all methods', () {
    test('string values', () async {
      await prefsService.saveStringValue('name', 'alice');
      String? name = await prefsService.getStringValue('name');
      expect(name, 'alice');
    });
    test('int values', () async {
      await prefsService.saveIntValue('age', 30);
      int? age = await prefsService.getIntValue('age');
      expect(age, 30);
    });
    test('bool values', () async {
      await prefsService.saveBoolValue('married', false);
      bool? married = await prefsService.getBoolValue('married');
      expect(married, false);
    });
  });
}
