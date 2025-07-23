import "package:summerbody/blocs/MuscleGroup/muscle_group_bloc.dart";
import "package:summerbody/blocs/Schedule/schedule_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

var blocProviders = [
  BlocProvider<MuscleGroupBloc>(
    create: (BuildContext context) => MuscleGroupBloc(),
  ),
  BlocProvider<ScheduleBloc>(
    create: (BuildContext context) => ScheduleBloc()..add(Initialize()),
  ),
];
