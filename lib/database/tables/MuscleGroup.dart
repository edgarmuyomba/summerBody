import 'package:floor/floor.dart';
import 'package:equatable/equatable.dart';

@Entity(tableName: 'MuscleGroups')
class MuscleGroup extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? name;
  final String? day;
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
}
