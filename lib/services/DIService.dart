import 'package:floor/floor.dart';
import 'package:summerbody/database/database.dart';
import 'package:summerbody/services/ConnectivityService.dart';
import 'package:summerbody/services/FirebaseService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';
import 'package:get_it/get_it.dart';
import 'package:summerbody/state/SyncState.dart';

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
      INSERT INTO Days (id, name) VALUES 
      (1, 'Monday'),
      (2, 'Tuesday'),
      (3, 'Wednesday'),
      (4, 'Thursday'),
      (5, 'Friday'),
      (6, 'Saturday'),
      (7, 'Sunday'),
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

    locator.registerSingleton<ConnectivityService>(ConnectivityService());

    locator.registerSingleton<FirebaseService>(FirebaseService());

    locator.registerSingleton<SyncStateModal>(SyncStateModal());
  }
}
