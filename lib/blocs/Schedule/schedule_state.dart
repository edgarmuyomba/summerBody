part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState extends Equatable {}

final class ScheduleInitial extends ScheduleState {
  @override
  List<Object?> get props => [];
}

final class ScheduleReady extends ScheduleState {
  final String currentDay;
  final MuscleGroup? musclegroup;
  final List<Workout> workouts;
  final Map<int, List<Set>> sets;

  ScheduleReady(
      {required this.currentDay,
      required this.musclegroup,
      required this.workouts,
      required this.sets});

  @override
  List<Object?> get props => [currentDay, musclegroup, workouts, sets];
}

final class WorkoutReady extends ScheduleState {
  final Workout workout;
  final List<Set> sets;

  WorkoutReady({required this.workout, required this.sets});

  @override
  List<Object?> get props => [workout, sets];
}
