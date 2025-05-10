import 'package:equatable/equatable.dart';
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
class Workout extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;

  @ColumnInfo(name: 'muscleGroupId')
  final int? muscleGroup;

  const Workout(
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

  @override
  List<Object> get props => [];

  @override
  int get hashCode => Object.hash(id, name, muscleGroup);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workout &&
        other.id == id &&
        other.name == name &&
        other.muscleGroup == muscleGroup;
  }
}
