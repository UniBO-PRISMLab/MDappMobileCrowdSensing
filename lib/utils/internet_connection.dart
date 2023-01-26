import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import '../main.dart';

class InternetConnection {
  static var connectionStatus;

  static Future<void> checkInternetConnectivity() async {
    connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus == ConnectivityResult.none) {
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            MaterialApp(home: Builder(
                builder: (_) => MyApp())),
        transitionDuration: Duration.zero,);
    }
  }
}