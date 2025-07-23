import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';

part 'muscle_group_event.dart';
part 'muscle_group_state.dart';

class MuscleGroupBloc extends Bloc<MuscleGroupEvent, MuscleGroupState> {
  final LocalDatabaseService _localDatabaseService;
  MuscleGroupBloc({LocalDatabaseService? localDatabaseService})
      : _localDatabaseService = localDatabaseService ??
            DIService().locator.get<LocalDatabaseService>(),
        super(MuscleGroupInitial()) {
    on<LoadMuscleGroups>(_onLoadMuscleGroups);
  }

  Future<void> _onLoadMuscleGroups(LoadMuscleGroups event, Emitter emit) async {
    List<MuscleGroup> muscleGroups =
        await _localDatabaseService.getMuscleGroupsByDay(event.selectDay);

    emit(MuscleGroupsLoaded(muscleGroups: muscleGroups));
  }
}
