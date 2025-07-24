part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState extends Equatable {}

final class ScheduleInitial extends ScheduleState {
  @override
  List<Object?> get props => [];
}

final class ScheduleReady extends ScheduleState {
  final int currentDay;
  final List<MuscleGroup> muscleGroups;

  ScheduleReady({
    required this.currentDay,
    required this.muscleGroups,
  });

  @override
  List<Object?> get props => [currentDay, muscleGroups];
}
