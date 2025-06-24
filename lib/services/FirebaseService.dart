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

  Future<List<Map<String, dynamic>>> fetchWorkoutSuggestions(
      String muscleGroup, String query) async {
    if (query.length < 5) return [];

    final collection = FirebaseFirestore.instance.collection(muscleGroup);
    final snapshot = await collection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
