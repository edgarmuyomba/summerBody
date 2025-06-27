part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleEvent {}

final class Initialize extends ScheduleEvent {}

final class SetDay extends ScheduleEvent {
  final String day;

  SetDay({required this.day});
}

final class AddMuscleGroup extends ScheduleEvent {
  final String muscleGroupName;
  final String day;

  AddMuscleGroup({required this.muscleGroupName, required this.day});
}

final class LoadWorkout extends ScheduleEvent {
  final int workoutId;

  LoadWorkout({required this.workoutId});
}

final class AddWorkout extends ScheduleEvent {
  final WorkoutPreset? workoutPreset;
  final String? workoutName;
  final DateTime date;
  final double weight1;
  final int reps1;
  final double? weight2;
  final int? reps2;

  AddWorkout(
      {this.workoutPreset,
      this.workoutName,
      required this.date,
      required this.weight1,
      required this.reps1,
      this.weight2,
      this.reps2});
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

final class CreateSet extends ScheduleEvent {
  final int workoutId;
  final DateTime date;
  final double weight1;
  final int reps1;
  final double? weight2;
  final int? reps2;
  final BuildContext context;

  CreateSet(
      {required this.workoutId,
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
