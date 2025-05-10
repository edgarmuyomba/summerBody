import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:summerbody/database/daos/EntryDao.dart';
import 'package:summerbody/database/daos/MuscleGroupDao.dart';
import 'package:summerbody/database/daos/WorkoutDao.dart';
import 'package:summerbody/database/database.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/database/tables/Workout.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';

@GenerateMocks([AppDatabase, MuscleGroupDao, WorkoutDao, EntryDao])
import 'localDatabaseService_test.mocks.dart';

final List<MuscleGroup> mockMuscleGroups = [
  const MuscleGroup(1, 'Chest', '', 'assets/icons/chest.png'),
  const MuscleGroup(2, 'Arms', '', 'assets/icons/arms.png'),
  const MuscleGroup(3, 'Shoulders', '', 'assets/icons/shoulders.png'),
  const MuscleGroup(4, 'Back', '', 'assets/icons/back.png'),
  const MuscleGroup(5, 'Legs', '', 'assets/icons/legs.png'),
];

void main() {
  late MockAppDatabase mockAppDatabase;
  late MockMuscleGroupDao mockMuscleGroupDao;
  late MockWorkoutDao mockWorkoutDao;
  late MockEntryDao mockEntryDao;
  late LocalDatabaseService localDatabaseService;

  setUp(() {
    mockAppDatabase = MockAppDatabase();
    mockMuscleGroupDao = MockMuscleGroupDao();
    mockWorkoutDao = MockWorkoutDao();
    mockEntryDao = MockEntryDao();

    when(mockAppDatabase.muscleGroupDao).thenReturn(mockMuscleGroupDao);
    when(mockAppDatabase.workoutDao).thenReturn(mockWorkoutDao);
    when(mockAppDatabase.entryDao).thenReturn(mockEntryDao);

    localDatabaseService = LocalDatabaseService(appDatabase: mockAppDatabase);
  });

  group("Local Database Service Tests", () {
    test("get all muscle groups", () async {
      when(mockMuscleGroupDao.getAllMuscleGroups())
          .thenAnswer((_) async => mockMuscleGroups);

      final result = await localDatabaseService.getAllMuscleGroups();

      expect(result, mockMuscleGroups);
      expect(result.length, 5);
      verify(mockAppDatabase.muscleGroupDao).called(1);
    });

    test("Get muscle group by key", () async {
      when(mockMuscleGroupDao.getMuscleGroupById(1)).thenAnswer(
          (realInvocation) async =>
              const MuscleGroup(1, 'Chest', '', 'assets/icons/chest.png'));

      when(mockMuscleGroupDao.getMuscleGroupsByName("Legs")).thenAnswer(
          (realInvocation) async =>
              [const MuscleGroup(5, 'Legs', '', 'assets/icons/legs.png')]);

      when(mockMuscleGroupDao.getMuscleGroupsByDay("Monday"))
          .thenAnswer((realInvocation) async => []);

      final result1 = await localDatabaseService.getMuscleGroupByKey("id", 1);
      final result2 =
          await localDatabaseService.getMuscleGroupByKey("name", "Legs");
      final result3 =
          await localDatabaseService.getMuscleGroupByKey("day", "Monday");

      expect(
          result1, const MuscleGroup(1, 'Chest', '', 'assets/icons/chest.png'));
      expect(
          result2, const MuscleGroup(5, 'Legs', '', 'assets/icons/legs.png'));
      expect(result3, isNull);
    });

    test('Get workouts by musclegroup', () async {
      when(mockWorkoutDao.getWorkoutsByMuscleGroup(1)).thenAnswer(
          (realInvocation) async => [const Workout(1, "Sample Workout", 1)]);

      final result = await localDatabaseService.getWorkoutsByMuscleGroup(1);

      expect(result, [const Workout(1, "Sample Workout", 1)]);
      verify(mockAppDatabase.workoutDao).called(1);
    });
  });
}
