import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'MuscleGroupPresets')
class MuscleGroupPreset extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  final String? icon;
  const MuscleGroupPreset({
    this.id,
    this.name,
    this.icon,
  });

  MuscleGroupPreset copyWith({
    int? id,
    String? name,
    String? icon,
  }) {
    return MuscleGroupPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory MuscleGroupPreset.fromMap(Map<String, dynamic> map) {
    return MuscleGroupPreset(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
    );
  }

  @override
  List<Object?> get props => [id, name, icon];

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MuscleGroupPreset &&
        other.id == id &&
        other.name == name &&
        other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(id, name, icon);
}
