part of 'muscleGroup_bloc.dart';

sealed class MuscleGroupState extends Equatable {
  const MuscleGroupState();

  @override
  List<Object> get props => [];
}

final class MuscleGroupInitial extends MuscleGroupState {}

final class MuscleGroupReady extends MuscleGroupState {
  final List<Workout> workouts;

  const MuscleGroupReady({required this.workouts});

  @override
  List<Object> get props => [workouts];
}

final class WorkoutReady extends MuscleGroupState {
  final Workout workout;
  final List<Set> sets;

  const WorkoutReady({required this.workout, required this.sets});

  @override
  // TODO: implement props
  List<Object> get props => [workout, sets];
}
