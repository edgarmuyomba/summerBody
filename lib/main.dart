import 'package:SummerBody/blocs/blocProviders.dart';
import 'package:SummerBody/screens/splash.dart';
import 'package:SummerBody/services/DIService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DIService().setupLocator();
  runApp(const MyApp());
  runApp(ScreenUtilInit(
      designSize: const Size(448.0, 973.34),
      builder: (context, child) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders, 
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ));
  }
}