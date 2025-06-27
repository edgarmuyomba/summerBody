import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:summerbody/database/typeConverters/stringListConverter.dart';
import 'package:summerbody/database/typeConverters/stringMapConverter.dart';

import 'MuscleGroup.dart';

@TypeConverters([StringListConverter, StringMapConverter])
@Entity(
  tableName: 'WorkoutPresets',
  foreignKeys: [
    ForeignKey(
      childColumns: ['muscleGroupId'],
      parentColumns: ['id'],
      entity: MuscleGroup,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class WorkoutPreset extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  final List<String>? equipment;
  final List<String>? subMuscles;
  final List<String>? steps;
  final Map<String, String?>? videoUrl;
  final Map<String, String?>? gifUrl;

  @ColumnInfo(name: 'muscleGroupId')
  final int? muscleGroup;

  const WorkoutPreset({
    this.id,
    this.name,
    this.equipment,
    this.subMuscles,
    this.steps,
    this.videoUrl,
    this.gifUrl,
    this.muscleGroup,
  });

  WorkoutPreset copyWith({
    int? id,
    String? name,
    List<String>? equipment,
    List<String>? subMuscles,
    List<String>? steps,
    Map<String, String?>? videoUrl,
    Map<String, String?>? gifUrl,
    int? muscleGroup,
  }) {
    return WorkoutPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      equipment: equipment ?? this.equipment,
      subMuscles: subMuscles ?? this.subMuscles,
      steps: steps ?? this.steps,
      videoUrl: videoUrl ?? this.videoUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }

  factory WorkoutPreset.fromMap(Map<String, dynamic> map, int? muscleGroupId) {
    return WorkoutPreset(
      id: map['id'] as int?,
      name: map['name'] as String?,
      equipment: map['equipment'] is String
          ? StringListConverter().decode(map['equipment'] as String)
          : List<String>.from(map['equipment'] ?? []),
      subMuscles: map['subMuscles'] is String
          ? StringListConverter().decode(map['subMuscles'] as String)
          : List<String>.from(map['subMuscles'] ?? []),
      steps: map['steps'] is String
          ? StringListConverter().decode(map['steps'] as String)
          : List<String>.from(map['steps'] ?? []),
      videoUrl: map['videoUrl'] is String
          ? StringMapConverter().decode(map['videoUrl'] as String)
          : Map<String, String?>.from(map['videoUrl'] ?? {}),
      gifUrl: map['gifUrl'] is String
          ? StringMapConverter().decode(map['gifUrl'] as String)
          : Map<String, String?>.from(map['gifUrl'] ?? {}),
      muscleGroup: muscleGroupId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      equipment,
      subMuscles,
      steps,
      videoUrl,
      gifUrl,
      muscleGroup,
    ];
  }

  @override
  int get hashCode => Object.hash(
      id, name, muscleGroup, equipment, subMuscles, steps, videoUrl, gifUrl);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutPreset &&
        other.id == id &&
        other.name == name &&
        other.muscleGroup == muscleGroup &&
        other.equipment == equipment &&
        other.subMuscles == subMuscles &&
        other.steps == steps &&
        other.videoUrl == videoUrl &&
        other.gifUrl == gifUrl;
  }
}
