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

final class EditWorkout extends ScheduleEvent {
  final int workoutId;
  final String workoutName;
  final int setId;
  final DateTime date;
  final double weight1;
  final int reps1;
  final double? weight2;
  final int? reps2;

  final BuildContext context;

  EditWorkout(
      {required this.workoutId,
      required this.workoutName,
      required this.setId,
      required this.date,
      required this.weight1,
      required this.reps1,
      this.weight2,
      this.reps2,
      required this.context});
}

final class DeleteSet extends ScheduleEvent {
  final int workoutId;
  final int setId;
  final BuildContext context;

  DeleteSet(
      {required this.workoutId, required this.setId, required this.context});
}
