import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/Day.dart';

@dao
abstract class DayDao {
  @Query('SELECT * FROM Days WHERE id = :id')
  Future<Day?> getDayById(int id);
}
