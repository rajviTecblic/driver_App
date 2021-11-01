import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
class InternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (BuildContext ctxt,
                AsyncSnapshot<ConnectivityResult> snapShot) {
              if (!snapShot.hasData) return CircularProgressIndicator();
              var result = snapShot.data;
              switch (result) {
                  case ConnectivityResult.none:
                  print("no net");
                  return Center(child: Text("No Internet Connection!"));
                case ConnectivityResult.mobile:
                case ConnectivityResult.wifi:
                  print("yes net");
                  return Center(
                    child: Text('Welcome to home Page'),
                  );
                default:
                  return Center(child: Text("No Internet Connection!"));
              }
            })
    );
  }
}
