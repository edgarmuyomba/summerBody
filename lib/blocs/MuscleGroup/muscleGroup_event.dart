part of 'muscleGroup_bloc.dart';

sealed class MuscleGroupEvent extends Equatable {
  const MuscleGroupEvent();

  @override
  List<Object> get props => [];
}

final class LoadWorkouts extends MuscleGroupEvent {
  final int muscleGroupId;

  const LoadWorkouts({required this.muscleGroupId});

  @override
  List<Object> get props => [muscleGroupId];
}

final class AddWorkout extends MuscleGroupEvent {
  final int muscleGroupId;
  final WorkoutPreset? workoutPreset;
  final String? workoutName;
  final DateTime date;
  final double weight1;
  final int reps1;
  final double? weight2;
  final int? reps2;

  const AddWorkout(
      {required this.muscleGroupId,
      this.workoutPreset,
      this.workoutName,
      required this.date,
      required this.weight1,
      required this.reps1,
      this.weight2,
      this.reps2});
}

final class LoadWorkout extends MuscleGroupEvent {
  final int workoutId;

  const LoadWorkout({required this.workoutId});
}

final class CreateSet extends MuscleGroupEvent {
  final int workoutId;
  final DateTime date;
  final double weight1;
  final int reps1;
  final double? weight2;
  final int? reps2;
  final BuildContext context;

  const CreateSet(
      {required this.workoutId,
      required this.date,
      required this.weight1,
      required this.reps1,
      this.weight2,
      this.reps2,
      required this.context});
}
