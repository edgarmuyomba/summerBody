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
  final int weight1;
  final int reps1;
  final int? weight2;
  final int? reps2;

  AddWorkout(
      {required this.workoutName,
      required this.weight1,
      required this.reps1,
      this.weight2,
      this.reps2});
}

final class DeleteWorkout extends ScheduleEvent {
  final int workoutId;

  DeleteWorkout({required this.workoutId});
}
