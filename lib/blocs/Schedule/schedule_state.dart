part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleReady extends ScheduleState {
  final String currentDay;
  final String? musclegroup;
  final List<Workout> workouts;

  ScheduleReady({required this.currentDay, required this.musclegroup, required this.workouts});
}
