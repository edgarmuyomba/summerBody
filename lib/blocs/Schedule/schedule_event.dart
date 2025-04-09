part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleEvent {}

final class Initialize extends ScheduleEvent {}

final class SetDay extends ScheduleEvent {
  final String day;

  SetDay({required this.day});
}
