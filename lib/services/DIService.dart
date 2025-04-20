import 'package:floor/floor.dart';
import 'package:summerbody/database/database.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
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

  Future<void> setupLocator() async {
    final callback = Callback(onCreate: (database, version) async {
      await database.execute('''
      INSERT INTO MuscleGroups (id, name, day, icon) VALUES 
      (1, 'Chest', '', 'assets/icons/chest.png'),
      (2, 'Arms', '', 'assets/icons/arms.png'),
      (3, 'Shoulders', '', 'assets/icons/shoulders.png'),
      (4, 'Back', '', 'assets/icons/back.png'),
      (5, 'Legs', '', 'assets/icons/legs.png')
    ''');
    });

    final database = await $FloorAppDatabase
        .databaseBuilder('summerbody.db')
        .addCallback(callback)
        .build();

    locator.registerSingleton<SharedPreferencesService>(
        SharedPreferencesService());

    locator.registerSingleton<AppDatabase>(database);

    locator.registerSingleton<LocalDatabaseService>(
        LocalDatabaseService(appDatabase: locator<AppDatabase>()));
  }
}
