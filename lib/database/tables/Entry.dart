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

  Entry copyWith({
    int? id,
    int? workout,
    double? weight1,
    int? reps1,
    double? weight2,
    int? reps2,
    int? date,
  }) {
    return Entry(
      id ?? this.id,
      workout ?? this.workout,
      weight1 ?? this.weight1,
      reps1 ?? this.reps1,
      weight2 ?? this.weight2,
      reps2 ?? this.reps2,
      date ?? this.date,
    );
  }
}
