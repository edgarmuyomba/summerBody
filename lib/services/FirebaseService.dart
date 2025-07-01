import "package:firebase_core/firebase_core.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:summerbody/firebase_options.dart";
import "package:summerbody/services/ConnectivityService.dart";
import "package:summerbody/services/DIService.dart";

class FirebaseService {
  final ConnectivityService _connectivityService;

  FirebaseService({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ??
            DIService().locator.get<ConnectivityService>();

  Future<void> initializeFirebase() async {
    if (await _connectivityService.hasInternetConnection()) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  Stream<List<Map<String, dynamic>>> workoutStream(String muscleGroup) async* {
    DocumentSnapshot? lastDoc;
    bool hasMore = true;

    while (hasMore) {
      final query = FirebaseFirestore.instance
          .collection(muscleGroup)
          .orderBy('name')
          .limit(100);

      final snapshot = await (lastDoc == null
          ? query.get()
          : query.startAfterDocument(lastDoc).get());

      if (snapshot.docs.isEmpty) {
        hasMore = false;
        break;
      }

      lastDoc = snapshot.docs.last;
      yield snapshot.docs.map((doc) => doc.data()).toList();
    }
  }

  Future<int> getRecordCount(String muscleGroup) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(muscleGroup).count().get();
    return querySnapshot.count ?? 0;
  }
}
