import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:summerbody/screens/day.dart';
import 'package:summerbody/screens/splash.dart';
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
      }),
  GoRoute(
      name: 'workouts',
      path: '/workouts/:muscleGroupName',
      builder: (BuildContext context, GoRouterState state) {
        final String muscleGroupName =
            state.pathParameters["muscleGroupName"] ?? "";
        return Workouts(muscleGroupName: muscleGroupName);
      }),
]);
