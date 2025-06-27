import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:summerbody/screens/day.dart';
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
      ]),
  GoRoute(
    name: 'workouts',
    path: '/workouts/:muscleGroupName',
    builder: (BuildContext context, GoRouterState state) {
      final String muscleGroupName =
          state.pathParameters["muscleGroupName"] ?? "";
      return Workouts(muscleGroupName: muscleGroupName);
    },
  ),
  GoRoute(
      name: 'workout',
      path: '/workout/:workoutId',
      builder: (BuildContext context, GoRouterState state) {
        final String workoutId = state.pathParameters["workoutId"] ?? "";
        return Workout(workoutId: int.parse(workoutId));
      }),
  GoRoute(
      name: 'workoutDetails',
      path: '/workoutDetails/:workoutId',
      builder: (BuildContext context, GoRouterState state) {
        final String workoutId = state.pathParameters["workoutId"] ?? "";
        return WorkoutDetails(workoutId: int.parse(workoutId));
      })
]);
