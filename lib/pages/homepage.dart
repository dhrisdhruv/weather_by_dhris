import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:quiver/iterables.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


class HomePage extends StatefulWidget {
  late Position position;
  final Dio dio = Dio();
  //final GetConnect connect = GetConnect();
  late List timeSeriesStamp, temperatureSeries;
  late List<WeatherData> weatherData;

  Future<dynamic> getWeather() async {

    final Response response = await dio.get(
      "https://api.open-meteo.com/v1/forecast",
      queryParameters: {"latitude": position.latitude, "longitude": position.longitude, "hourly": "temperature_2m"},
    );
    timeSeriesStamp = response.data["hourly"]["time"].map((e)=>DateTime.parse(e.toString())).toList();
    temperatureSeries = response.data["hourly"]["temperature_2m"];
    weatherData = zip([timeSeriesStamp, temperatureSeries]).toList().map((e) => WeatherData(e[0], e[1])).toList();
    return response.data;
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

class WeatherData {
  DateTime time;
  double temperature;
  WeatherData(this.time,this.temperature);
}

class ShowGraph extends StatelessWidget {
  List<WeatherData> weatherData;
  ShowGraph(this.weatherData);
  @override
  Widget build(BuildContext context) {
    return charts.SfCartesianChart(
      primaryXAxis: charts.DateTimeAxis(),
      series: <charts.ChartSeries>[
        charts.LineSeries(
            dataSource: weatherData,
            xValueMapper: (WeatherData weather, _)=>weather.time.hour,
            yValueMapper: yValueMapper)
      ],
    );
  }

}