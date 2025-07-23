import "package:summerbody/blocs/MuscleGroup/muscleGroup_bloc.dart";
import "package:summerbody/blocs/Schedule/schedule_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

var blocProviders = [
  BlocProvider<ScheduleBloc>(
    create: (BuildContext context) => ScheduleBloc()..add(Initialize()),
  ),
  BlocProvider<MuscleGroupBloc>(
    create: (BuildContext context) => MuscleGroupBloc(),
  ),
];
