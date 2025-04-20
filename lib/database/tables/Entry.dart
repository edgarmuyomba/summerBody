import 'package:summerbody/database/tables/Workout.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'Entries',
  foreignKeys: [
    ForeignKey(
      childColumns: ['workoutId'],
      parentColumns: ['id'],
      entity: Workout,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Entry {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'workoutId')
  final int? workout;

  final double? weight1;
  final int? reps1;
  final double? weight2;
  final int? reps2;
  final int? date;

  Entry(
    this.id,
    this.workout,
    this.weight1,
    this.reps1,
    this.weight2,
    this.reps2,
    this.date,
  );
}
