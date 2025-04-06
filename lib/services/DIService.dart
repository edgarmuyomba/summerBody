import 'package:SummerBody/services/SharedPreferencesService.dart';
import 'package:get_it/get_it.dart';

class DIService {
  DIService._();

  static final DIService _diService = DIService._();

  factory DIService() {
    return _diService;
  }

  GetIt locator = GetIt.instance;

  void setupLocator() {
    locator.registerSingleton<SharedPreferencesService>(
        SharedPreferencesService());
  }
}
