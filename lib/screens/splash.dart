import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:summerbody/routing/routes.dart';
import 'package:logger/logger.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<ScheduleBloc, ScheduleState>(
      // bloc: context.read<ScheduleBloc>(),
      listener: (context, state) async {
        DateTime now = DateTime.now();
        String currentDay = now.weekday == DateTime.monday
            ? 'monday'
            : now.weekday == DateTime.tuesday
                ? 'tuesday'
                : now.weekday == DateTime.wednesday
                    ? 'wednesday'
                    : now.weekday == DateTime.thursday
                        ? 'thursday'
                        : now.weekday == DateTime.friday
                            ? 'friday'
                            : now.weekday == DateTime.saturday
                                ? 'saturday'
                                : 'sunday';

        if (state is ScheduleReady) {
          Future.delayed(
              const Duration(seconds: 2),
              () => context.goNamed(Routes.day,
                  pathParameters: {"currentDay": currentDay}));
        }
      },
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }
}
