import 'package:flutter/material.dart';
import 'package:open_weather_demo/home/home_screen.dart';
import 'package:open_weather_demo/util/helper_class.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with HelperClass {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      pushToScreenAndClearStack(context, HomeScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome to WeatherApp",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
