import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'MuscleGroupPresets'
)
class MuscleGroupPreset extends Equatable {
  @PrimaryKey()
  final String? name;
  final String? icon;
  const MuscleGroupPreset({
    this.name,
    this.icon,
  });

  MuscleGroupPreset copyWith({
    String? name,
    String? icon,
  }) {
    return MuscleGroupPreset(
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'icon': icon,
    };
  }

  factory MuscleGroupPreset.fromMap(Map<String, dynamic> map) {
    return MuscleGroupPreset(
      name: map['name'] != null ? map['name'] as String : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
    );
  }

  @override
  List<Object?> get props => [name, icon];

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MuscleGroupPreset &&
        other.name == name &&
        other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(name, icon);
}
