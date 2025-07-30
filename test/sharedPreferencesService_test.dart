import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';
import 'sharedPreferencesService_test.mocks.dart';

@GenerateMocks([SharedPreferencesService])
void main() {
  late MockSharedPreferencesService sharedPrefsService;

  setUp(() {
    sharedPrefsService = MockSharedPreferencesService();
  });

  group("Shared Preferences Tests", () {
    test("Saving a string", () async {
      sharedPrefsService.saveStringValue("name", "edgarmuyomba");

      verify(sharedPrefsService.saveStringValue("name", "edgarmuyomba"))
          .called(1);
    });
    test("Saving a bool", () async {
      sharedPrefsService.saveBoolValue("saved", false);

      verify(sharedPrefsService.saveBoolValue("saved", false)).called(1);
    });
    test("Saving an int", () async {
      sharedPrefsService.saveIntValue("value", 34);

      verify(sharedPrefsService.saveIntValue("value", 34)).called(1);
    });

    test("Fetching a string", () async {
      when(sharedPrefsService.getStringValue("name"))
          .thenAnswer((_) async => "edgarmuyomba");

      expect(await sharedPrefsService.getStringValue("name"), "edgarmuyomba");
    });

    test("Fetching a bool", () async {
      when(sharedPrefsService.getBoolValue("saved"))
          .thenAnswer((_) async => false);

      expect(await sharedPrefsService.getBoolValue("saved"), false);
    });

    test("Fetching an int", () async {
      when(sharedPrefsService.getIntValue("value"))
          .thenAnswer((_) async => 34);

      expect(await sharedPrefsService.getIntValue("value"), 34);
    });
  });
}
