part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleEvent {}

final class Initialize extends ScheduleEvent {}

final class ChangeDay extends ScheduleEvent {
  final bool next;

  ChangeDay({required this.next});
}

final class AddMuscleGroup extends ScheduleEvent {
  final MuscleGroupPreset muscleGroupPreset;

  AddMuscleGroup({required this.muscleGroupPreset});
}

final class DeleteMuscleGroup extends ScheduleEvent {
  final int muscleGroupId;

  DeleteMuscleGroup({required this.muscleGroupId});
}
