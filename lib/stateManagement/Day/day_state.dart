part of 'day_cubit.dart';

sealed class DayState extends Equatable {
  const DayState();

  @override
  List<Object> get props => [];
}

final class DayInitial extends DayState {
  final int selectDay;

  const DayInitial({required this.selectDay});

  @override
  List<Object> get props => [selectDay];
}

final class CurrentDay extends DayState {
  final int selectDay;

  const CurrentDay({required this.selectDay});

  @override
  List<Object> get props => [selectDay];
}
