part of 'muscle_group_bloc.dart';

sealed class MuscleGroupEvent extends Equatable {
  const MuscleGroupEvent();

  @override
  List<Object> get props => [];
}

final class LoadMuscleGroups extends MuscleGroupEvent {
  final int selectDay;

  const LoadMuscleGroups({required this.selectDay});

  @override
  List<Object> get props => [selectDay];
}
