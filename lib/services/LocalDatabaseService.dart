import 'package:SummerBody/database/database.dart';
import 'package:SummerBody/services/DIService.dart';

class LocalDatabaseService {
  final AppDatabase appDatabase;

  LocalDatabaseService({AppDatabase? appDatabase})
      : appDatabase = appDatabase ?? DIService().locator.get<AppDatabase>();
}
