import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  late Position position;
  final Dio dio = Dio();
  final GetConnect connect = GetConnect();
  late List temp;

  Future<dynamic> getWeather() async {
    /*
    final Response response = await dio.post("https://api.open-meteo.com/v1/forecast/",
        data: {"latitude": position.latitude, "longitude": position.longitude, "hourly": "temperature_2m"},
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    );
    return response.data;

     */
    final response = await connect.post(
      "https://api.open-meteo.com/v1/forecast/",
      {
        "latitude": 52.52,
        "longitude": 13.41,
        "hourly": "temperature_2m"
      }
    );
    return response.status.isOk;
  }

  Future<Position> getLocation() async {
    position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: widget.getLocation(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              return FutureBuilder(
                future: widget.getWeather(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.data == null) {
                    return CircularProgressIndicator();
                  }
                  else {
                    return Text(snapshot.data.toString());
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

}

