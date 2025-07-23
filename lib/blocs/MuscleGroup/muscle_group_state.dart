part of 'muscle_group_bloc.dart';

sealed class MuscleGroupState extends Equatable {
  const MuscleGroupState();

  @override
  List<Object> get props => [];
}

final class MuscleGroupInitial extends MuscleGroupState {}

final class MuscleGroupsLoaded extends MuscleGroupState {
  final List<MuscleGroup> muscleGroups;

  const MuscleGroupsLoaded({required this.muscleGroups});

  @override
  List<Object> get props => [muscleGroups];
}
