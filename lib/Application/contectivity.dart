import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  Stream<ConnectivityResult> connectivityStream() {
    return Connectivity().onConnectivityChanged;
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
