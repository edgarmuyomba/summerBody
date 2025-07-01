import 'package:flutter/material.dart';
import 'package:summerbody/models/WorkoutSelectorState.dart';

class WorkoutSelectorModel extends ChangeNotifier {
  WorkoutSelectorstate workoutSelectorState;

  WorkoutSelectorModel()
      : workoutSelectorState = const WorkoutSelectorstate(
            workoutDetailsActive: false, workoutId: null);

  void setWorkoutDetails(bool workoutDetailsActive, int? workoutId) {
    workoutSelectorState = workoutSelectorState.copyWith(
        workoutDetailsActive: workoutDetailsActive, workoutId: workoutId);
    notifyListeners();
  }
}
