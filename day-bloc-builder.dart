BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleReady) {
            return Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.chevron_left,
                          size: 50.sp,
                        ),
                        onTap: () {
                          context.read<ScheduleBloc>().add(SetDay(
                              day: getDay(state.currentDay, prev: true)));
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            capitalize(state.currentDay),
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          Text("Day of the week",
                              style: TextStyle(fontSize: 10.sp))
                        ],
                      ),
                      GestureDetector(
                        child: Icon(Icons.chevron_right, size: 50.sp),
                        onTap: () {
                          context
                              .read<ScheduleBloc>()
                              .add(SetDay(day: getDay(state.currentDay)));
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: const Divider(),
                  ),
                  if (state.musclegroup == null) ...[
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          selectMuscleGroupName = null;
                        });
                        await addMuscleGroup(state.currentDay);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 75.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.w),
                            const Text(
                              "Add Muscle Group",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ] else ...[
                    SizedBox(height: 8.0.h),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Center(
                          child: Image(
                              height: 300.h,
                              image: AssetImage(
                                state.musclegroup!.icon!,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => showActionBottomSheet("add"),
                              tooltip: "Add muscle group",
                              constraints: BoxConstraints(
                                  maxWidth: 10.w, maxHeight: 10.w),
                              icon: Icon(
                                Icons.add,
                                size: 17.sp,
                              ),
                            ),
                            IconButton(
                              onPressed: () => showActionBottomSheet("edit"),
                              tooltip: "Edit muscle group",
                              constraints: BoxConstraints(
                                  maxWidth: 10.w, maxHeight: 10.w),
                              icon: Icon(
                                Icons.edit,
                                size: 17.sp,
                              ),
                            ),
                            IconButton(
                              onPressed: () => showActionBottomSheet("delete"),
                              tooltip: "Delete muscle group",
                              constraints: BoxConstraints(
                                  maxWidth: 10.w, maxHeight: 10.w),
                              icon: Icon(
                                Icons.cancel,
                                size: 17.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: const Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Workouts",
                          style: GoogleFonts.monda(
                              fontSize: 18.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        if (state.workouts.isNotEmpty) ...[
                          IconButton(
                              onPressed: () {
                                context.pushNamed(Routes.workouts,
                                    pathParameters: {
                                      "muscleGroupName":
                                          state.musclegroup!.name!
                                    });
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.black87,
                              ))
                        ]
                      ],
                    ),
                    if (state.workouts.isEmpty) ...[
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "You have no workouts for the ",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text:
                                        "${state.musclegroup!.name!.toLowerCase()}.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pushNamed(Routes.workouts,
                                    pathParameters: {
                                      "muscleGroupName":
                                          state.musclegroup!.name!
                                    });
                              },
                              child: Text(
                                "Add Some",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ] else ...[
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          children: state.workouts.map((workout) {
                            Map<String, dynamic> workoutMap = {
                              "id": workout.id,
                              "name": workout.name,
                              "isSuggested": workout.isSuggested,
                              "sets": (state.sets[workout.id] ?? []).map((set) {
                                return {
                                  "weight1": set.weight1,
                                  "reps1": set.reps1,
                                  "weight2": set.weight2,
                                  "reps2": set.reps2,
                                  "date": set.date!.toString()
                                };
                              }).toList()
                            };
                            return WorkoutWidget(
                              workout: workoutMap,
                            );
                          }).toList(),
                        )),
                      )
                    ]
                  ]
                ],
              ),
            );
         
          }
          return const SizedBox.shrink();
        },
      ),