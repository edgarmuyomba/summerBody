import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:summerbody/screens/day.dart';
import 'package:summerbody/screens/settings.dart';
import 'package:summerbody/screens/splash.dart';
import 'package:summerbody/screens/timer.dart';
import 'package:summerbody/screens/workout.dart';
import 'package:summerbody/screens/workoutDetails.dart';
import 'package:summerbody/screens/workouts.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Splash();
      }),
  GoRoute(
      name: 'day',
      path: '/day',
      builder: (BuildContext context, GoRouterState state) {
        return Day();
      },
      routes: [
        GoRoute(
          name: 'timer',
          path: '/timer',
          builder: (BuildContext context, GoRouterState state) {
            return const Timer();
          },
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return Settings();
          },
        ),
      ]),
  GoRoute(
    name: 'workouts',
    path: '/workouts/:muscleGroupId',
    builder: (BuildContext context, GoRouterState state) {
      final int muscleGroupId =
          int.parse(state.pathParameters["muscleGroupId"] ?? "0");
      return Workouts(muscleGroupId: muscleGroupId);
    },
  ),
  GoRoute(
      name: 'workout',
      path:
          '/workout/:workoutId/:muscleGroupId/:triggerSetup/:loadWorkoutsOnBack',
      builder: (BuildContext context, GoRouterState state) {
        final String workoutId = state.pathParameters["workoutId"] ?? "";
        final String muscleGroupId =
            state.pathParameters["muscleGroupId"] ?? "";
        final bool triggerSetup =
            bool.parse(state.pathParameters["triggerSetup"] ?? 'false');
        final bool loadWorkoutsOnBack =
            bool.parse(state.pathParameters["loadWorkoutsOnBack"] ?? 'false');
        return Workout(
          workoutId: int.parse(workoutId),
          muscleGroupId: int.parse(muscleGroupId),
          triggerSetup: triggerSetup,
          loadWorkoutsOnBack: loadWorkoutsOnBack,
        );
      }),
  GoRoute(
      name: 'workoutDetails',
      path: '/workoutDetails/:workoutId/:muscleGroupId/:loadWorkoutsOnBack',
      builder: (BuildContext context, GoRouterState state) {
        final String workoutId = state.pathParameters["workoutId"] ?? "";
        final String muscleGroupId =
            state.pathParameters["muscleGroupId"] ?? "";
        final bool loadWorkoutsOnBack =
            bool.parse(state.pathParameters["loadWorkoutsOnBack"] ?? 'false');
        return WorkoutDetails(
          workoutId: int.parse(workoutId),
          muscleGroupId: int.parse(muscleGroupId),
          loadWorkoutsOnBack: loadWorkoutsOnBack,
        );
      })
]);
