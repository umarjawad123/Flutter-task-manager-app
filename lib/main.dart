import 'package:flutter/material.dart';
import 'package:task_manager/screens/splash_screen.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';

void main() {

  runApp(

    ChangeNotifierProvider(

      create: (_) => TaskProvider(),

      child: const MyApp(),

    ),

  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stride',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryBackground,

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBackground,
          foregroundColor: Colors.white,
        ),

        colorScheme: ColorScheme.dark(
          primary: AppColors.accentOrange,
          secondary: AppColors.lightOrange,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
