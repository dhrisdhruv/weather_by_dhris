import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:quiver/iterables.dart';


class HomePage extends StatefulWidget {
  late Position position;
  final Dio dio = Dio();
  //final GetConnect connect = GetConnect();
  late List timeSeriesStamp, temperatureSeries;
  late List weatherSeries;

  Future<dynamic> getWeather() async {

    final Response response = await dio.get(
      "https://api.open-meteo.com/v1/forecast",
      queryParameters: {"latitude": position.latitude, "longitude": position.longitude, "hourly": "temperature_2m"},
    );
    timeSeriesStamp = response.data["hourly"]["time"].map((e)=>DateTime.parse(e.toString()).hour.toDouble()).toList();
    temperatureSeries = response.data["hourly"]["temperature_2m"];
    timeSeriesStamp.length = 20;
    temperatureSeries.length = 20;
    weatherSeries = zip([timeSeriesStamp,temperatureSeries]).toList();
    return weatherSeries;
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
  void setState(VoidCallback fn) {
    widget.getLocation();
    widget.getWeather();
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                        return ShowGraph(snapshot.data);
                      }
                    },
                  );
                }
              },
            ),
          ),
        ),
    );

  }

}

class ShowGraph extends StatelessWidget {
  final List points;
  ShowGraph(this.points);

  @override
  Widget build(BuildContext context) {
    /*
    int screenWidth = MediaQuery.of(context).size.width.toInt();
    int screenHeight = MediaQuery.of(context).size.height.toInt();
    int min,max;
    if(screenWidth<screenHeight) {
      min = screenWidth; max = screenHeight;
    } else {
      min = screenHeight; max = screenWidth;
    }
    */

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: points.map((point)=>FlSpot(point[0], point[1])).toList(),
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

}