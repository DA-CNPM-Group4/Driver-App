import 'package:firebase_database/firebase_database.dart';

class FirestoreRealtimeProvider {
  // make this nullable by adding '?'
  static FirestoreRealtimeProvider? _instance;

  static FirestoreRealtimeProvider get instance {
    return _instance ??= FirestoreRealtimeProvider._();
  }

  late FirebaseDatabase database;
  late DatabaseReference onlDriversRef;
  late DatabaseReference requestsRef;

  FirestoreRealtimeProvider._() {
    database = FirebaseDatabase.instance;
    onlDriversRef = database.ref(FirebaseRealtimePaths.ONLINE_DRIVERS);
    requestsRef = database.ref(FirebaseRealtimePaths.REQUESTS);
    // initialization and stuff
  }

  factory FirestoreRealtimeProvider() {
    _instance ??= FirestoreRealtimeProvider._();
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }
}

abstract class FirebaseRealtimePaths {
  FirebaseRealtimePaths._();
  static const ONLINE_DRIVERS = 'requests';
  static const TRIPS = 'trips';
  static const REQUESTS = 'onlDrivers';
}
