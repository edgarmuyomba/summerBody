import "package:firebase_core/firebase_core.dart";
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
}
