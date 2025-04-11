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

final class AddWorkout extends ScheduleEvent {
  final String workoutName;
  final int weight;
  final int sets;
  final int reps;

  AddWorkout(
      {required this.workoutName,
      required this.weight,
      required this.sets,
      required this.reps});
}

final class DeleteWorkout extends ScheduleEvent {
  final int workoutId;

  DeleteWorkout({required this.workoutId});
}
