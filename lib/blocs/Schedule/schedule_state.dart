part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleReady extends ScheduleState {
  final String? musclegroup;
  final List<Workout> workouts;

  ScheduleReady({required this.musclegroup, required this.workouts});
}
