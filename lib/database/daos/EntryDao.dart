import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/Entry.dart';


@dao
abstract class EntryDao {
  @insert
  Future<void> createEntry(Entry entry);

  @update
  Future<void> editEntry(Entry entry);

  @Query('SELECT * FROM Entries')
  Future<List<Entry>> getAllEntries();

  @Query('DELETE FROM Entries WHERE id = :id AND workout = :workoutId')
  Future<void> deleteEntryById(int workoutId, int id);

  @Query('SELECT * FROM Entries WHERE id = :id')
  Future<Entry?> getEntryById(int id);

  @Query('SELECT * FROM Entries WHERE workout = :workout')
  Future<List<Entry>> getEntriesByWorkoutId(int workout);
}
