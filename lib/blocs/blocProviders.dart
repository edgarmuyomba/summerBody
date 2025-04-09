import "package:summerbody/blocs/Schedule/schedule_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

var blocProviders = [
  BlocProvider(
    create: (BuildContext context) => ScheduleBloc()..add(Initialize()),
  )
];
