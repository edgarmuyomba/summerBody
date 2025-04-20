import 'package:floor/floor.dart';
import 'MuscleGroup.dart';

@Entity(
  tableName: 'Workouts',
  foreignKeys: [
    ForeignKey(
      childColumns: ['muscleGroupId'],
      parentColumns: ['id'],
      entity: MuscleGroup,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Workout {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;

  @ColumnInfo(name: 'muscleGroupId')
  final int? muscleGroup;

  Workout(
    this.id,
    this.name,
    this.muscleGroup,
  );

  Workout copyWith({int? id, String? name, int? muscleGroup}) {
    return Workout(
      id ?? this.id,
      name ?? this.name,
      muscleGroup ?? this.muscleGroup,
    );
  }
}
