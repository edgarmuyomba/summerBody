import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:summerbody/routing/routes.dart';
import 'package:logger/logger.dart';
import 'package:google_fonts/google_fonts.dart';

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
              () => context.goNamed(Routes.day));
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SpinKitFadingCircle(
                color: Colors.black,
                size: 40.0.h,
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              "Summer Body",
              style: GoogleFonts.monda(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "by Edgar",
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    ));
  }
}
