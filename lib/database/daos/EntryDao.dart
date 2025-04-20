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

  @delete
  Future<void> deleteEntry(Entry entry);
}
