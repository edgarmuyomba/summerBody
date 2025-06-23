import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:summerbody/database/typeConverters/stringListConverter.dart';
import 'package:summerbody/database/typeConverters/stringMapConverter.dart';

import 'MuscleGroup.dart';

@TypeConverters([StringListConverter, StringMapConverter])
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
  final bool isSuggested;
  final List<String>? equipment;
  final List<String>? subMuscles;
  final List<String>? steps;
  final Map<String, String?>? videoUrl;
  final Map<String, String?>? gifUrl;

  @ColumnInfo(name: 'muscleGroupId')
  final int? muscleGroup;

  const Workout({
    this.id,
    this.name,
    required this.isSuggested,
    this.equipment,
    this.subMuscles,
    this.steps,
    this.videoUrl,
    this.gifUrl,
    this.muscleGroup,
  });

  Workout copyWith({
    int? id,
    String? name,
    bool? isSuggested,
    List<String>? equipment,
    List<String>? subMuscles,
    List<String>? steps,
    Map<String, String?>? videoUrl,
    Map<String, String?>? gifUrl,
    int? muscleGroup,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      isSuggested: isSuggested ?? this.isSuggested,
      equipment: equipment ?? this.equipment,
      subMuscles: subMuscles ?? this.subMuscles,
      steps: steps ?? this.steps,
      videoUrl: videoUrl ?? this.videoUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      isSuggested,
      equipment,
      subMuscles,
      steps,
      videoUrl,
      gifUrl,
      muscleGroup,
    ];
  }

  @override
  int get hashCode => Object.hash(id, name, muscleGroup, isSuggested, equipment,
      subMuscles, steps, videoUrl, gifUrl);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workout &&
        other.id == id &&
        other.name == name &&
        other.muscleGroup == muscleGroup &&
        other.isSuggested == isSuggested &&
        other.equipment == equipment &&
        other.subMuscles == subMuscles &&
        other.steps == steps &&
        other.videoUrl == videoUrl &&
        other.gifUrl == gifUrl;
  }
}
