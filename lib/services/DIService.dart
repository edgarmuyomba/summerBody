import 'package:summerbody/database/database.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';
import 'package:get_it/get_it.dart';

class DIService {
  DIService._();

  static final DIService _diService = DIService._();

  factory DIService() {
    return _diService;
  }

  GetIt locator = GetIt.instance;

  void setupLocator() async {

    final database = await $FloorAppDatabase.databaseBuilder('summerbody.db').build();

    locator.registerSingleton<SharedPreferencesService>(
        SharedPreferencesService());

    locator.registerSingleton<AppDatabase>(database);

    locator.registerSingleton<LocalDatabaseService>(
        LocalDatabaseService(appDatabase: locator<AppDatabase>()));
  }
}
