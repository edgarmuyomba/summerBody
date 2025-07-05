import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'day_state.dart';

class DayCubit extends Cubit<DayState> {
  int currentDay = DateTime.now().weekday;

  DayCubit() : super(DayInitial(selectDay: DateTime.now().weekday));

  void nextDay() {
    currentDay++;
    if (currentDay > 7) {
      currentDay = 1;
    }
    emit(CurrentDay(selectDay: currentDay));
  }

  void previousDay() {
    currentDay--;
    if (currentDay < 1) {
      currentDay = 7;
    }
    emit(CurrentDay(selectDay: currentDay));
  }
}
