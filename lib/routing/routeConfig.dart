import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:summerbody/screens/day.dart';
import 'package:summerbody/screens/splash.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Splash();
      }),
  GoRoute(
      name: 'day',
      path: '/day/:currentDay',
      builder: (BuildContext context, GoRouterState state) {
        final currentDay = state.pathParameters["currentDay"] ?? "monday";
        return Day(currentDay: currentDay);
      })
]);
