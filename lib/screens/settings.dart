import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/models/SyncState.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/state/SyncState.dart';
import 'package:summerbody/utils/utilities.dart';

class Settings extends StatefulWidget {
  final SyncStateModal _syncStateModal;
  Settings({super.key, SyncStateModal? syncStateModal})
      : _syncStateModal =
            syncStateModal ?? DIService().locator.get<SyncStateModal>();

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: GoogleFonts.monda(
              fontSize: 24.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sync Workouts",
                      style: GoogleFonts.monda(
                          fontSize: 18.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10.h),
                    StreamBuilder<SyncState>(
                        stream: widget._syncStateModal.stream,
                        builder: (context, asyncSnapshot) {
                          bool isSyncing =
                              asyncSnapshot.data?.isSyncing ?? false;
                          bool active = asyncSnapshot.data?.active ?? true;
                          double syncProgress =
                              asyncSnapshot.data?.syncProgress ?? 0.0;
                          return Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: Colors.grey[400]!)),
                                  child: isSyncing
                                      ? Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: SizedBox(
                                            height: 15.h,
                                            width: 15.h,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 3.0,
                                              color: Color(0xffe80c53),
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (active) {
                                              Utilities.syncWorkoutPresets();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Icon(
                                              Icons.sync,
                                              color: active
                                                  ? Colors.black87
                                                  : Colors.black45,
                                            ),
                                          ),
                                        )),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      height: 7.h,
                                      width: constraints.maxWidth,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black12),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: syncProgress,
                                        child: Container(
                                          height: 7.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: const Color(0xffe80c53)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
