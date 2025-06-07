part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

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
}

final class WorkoutReady extends ScheduleState {
  final Workout workout;
  final List<Set> sets;

  WorkoutReady({required this.workout, required this.sets});
}
