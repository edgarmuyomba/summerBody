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
