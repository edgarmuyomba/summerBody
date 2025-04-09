part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleReady extends ScheduleState {
  final List<Workout> workouts;

  ScheduleReady({required this.workouts});
}
