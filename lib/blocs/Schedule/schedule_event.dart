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

final class DeleteWorkout extends ScheduleEvent {
  final int workoutId;

  DeleteWorkout({required this.workoutId});
}

final class DeleteSet extends ScheduleEvent {
  final int workoutId;
  final int setId;
  final BuildContext context;

  DeleteSet(
      {required this.workoutId, required this.setId, required this.context});
}
