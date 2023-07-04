import 'package:flutter/material.dart';
import 'package:weather_by_dhris/pages/permission_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context){
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PermissionPage()));
                  },
                  child: const Text("Lets Begin"),
                ),
              ],
            ),
          ),
        );
      })
    );
  }

}