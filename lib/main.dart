import 'package:summerbody/blocs/blocProviders.dart';
import 'package:summerbody/routing/routeConfig.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summerbody/services/FirebaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DIService().setupLocator();
  await DIService().locator.get<FirebaseService>().initializeFirebase();

  await DIService().locator.allReady();
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
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        ));
  }
}
