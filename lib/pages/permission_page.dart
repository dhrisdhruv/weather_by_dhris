import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_by_dhris/pages/homepage.dart';

Future<bool> _checkLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled) {
    return false;
    //return Future.error("Location services are disabled");
  }
  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      return false;
      //return Future.error("Location permissions are denied");
    }
  }
  if(permission == LocationPermission.deniedForever) {
    return false;
    //return Future.error("Location permissions are permanently denied, we cannot request permissions");
  }
  return true;
  //return await Geolocator.getCurrentPosition();
}



class PermissionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              if(await _checkLocationPermission()) {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              }
            },
            child: const Text("Enable Location"),
          ),
        ],
      ),
    );
  }

}