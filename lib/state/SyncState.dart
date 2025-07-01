import 'package:rxdart/rxdart.dart';
import 'package:summerbody/models/SyncState.dart';

class SyncStateModal {
  final subject = BehaviorSubject<SyncState>();

  SyncStateModal() {
    subject.add(
        const SyncState(isSyncing: false, syncProgress: 0.0, active: true));
  }

  SyncState? get value => subject.valueOrNull;

  Stream<SyncState> get stream => subject.stream;

  void update({bool? isSyncing, double? syncProgress, bool? active}) {
    SyncState? syncState = subject.valueOrNull;
    if (isSyncing != null || syncProgress != null) {
      final newState = (syncState ??
              const SyncState(
                  isSyncing: false, syncProgress: 0.0, active: true))
          .copyWith(
              isSyncing: isSyncing ?? syncState?.isSyncing,
              syncProgress: syncProgress ?? syncState?.syncProgress,
              active: active ?? syncState?.active);
      subject.add(newState);
    }
  }
}
