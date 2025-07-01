// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class WorkoutSelectorstate extends Equatable {
  final bool workoutDetailsActive;
  final int? workoutId;
  const WorkoutSelectorstate({
    required this.workoutDetailsActive,
    this.workoutId,
  });

  WorkoutSelectorstate copyWith({
    bool? workoutDetailsActive,
    int? workoutId,
  }) {
    return WorkoutSelectorstate(
      workoutDetailsActive: workoutDetailsActive ?? this.workoutDetailsActive,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workoutDetailsActive': workoutDetailsActive,
      'workoutId': workoutId,
    };
  }

  factory WorkoutSelectorstate.fromMap(Map<String, dynamic> map) {
    return WorkoutSelectorstate(
      workoutDetailsActive: map['workoutDetailsActive'] as bool,
      workoutId: map['workoutId'] != null ? map['workoutId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSelectorstate.fromJson(String source) => WorkoutSelectorstate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [workoutDetailsActive, workoutId];
}
