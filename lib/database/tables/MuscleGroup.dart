import 'package:floor/floor.dart';
import 'package:equatable/equatable.dart';
import 'package:summerbody/database/tables/Day.dart';

@Entity(
  tableName: 'MuscleGroups',
  foreignKeys: [
    ForeignKey(
      childColumns: ['dayId'],
      parentColumns: ['id'],
      entity: Day,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class MuscleGroup extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? name;

  @ColumnInfo(name: 'dayId')
  final int? day;
  final String? icon;

  const MuscleGroup(
    this.id,
    this.name,
    this.day,
    this.icon,
  );

  @override
  List<Object> get props => [];

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MuscleGroup &&
        other.id == id &&
        other.name == name &&
        other.day == day &&
        other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(id, name, day, icon);

  factory MuscleGroup.fromMap(Map<String, dynamic> map) {
    return MuscleGroup(
      map['id'] as int?,
      map['name'] as String?,
      map['dayId'] as int?,
      map['icon'] as String?,
    );
  }
}
