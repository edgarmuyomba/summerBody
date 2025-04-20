import 'package:floor/floor.dart';

@Entity(tableName: 'MuscleGroups')
class MuscleGroup {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? name;
  final String? day;
  final String? icon;

  MuscleGroup(
    this.id,
    this.name,
    this.day,
    this.icon,
  );
}
