import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds:3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
            AppColors.primaryBackground,
            const Color.fromARGB(255, 169, 93, 0)
          ])
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt, color: AppColors.accentOrange, size: 64),
              SizedBox(height: 10,),
              Text("Stride", 
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryText),
              ),
              SizedBox(height: 10,),
              Text("Reach your daily peak", 
              style: TextStyle(fontSize: 20, color: AppColors.secondaryText),
              )
            ],
          ),
        ),
      ));
  }
}
