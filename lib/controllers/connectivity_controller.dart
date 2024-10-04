import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../models/connectivity_model.dart';

class ConnectivityController extends GetxController {
  ConnectivityModal connectivityModal =
      ConnectivityModal(isNetworkAvailable: false);

  void checkConnectivity() {
    Connectivity connectivity = Connectivity();

    Stream<List<ConnectivityResult>> stream =
        connectivity.onConnectivityChanged;

    stream.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        connectivityModal.isNetworkAvailable = true;
      } else {
        connectivityModal.isNetworkAvailable = false;
      }
      update();
    });
  }
}
