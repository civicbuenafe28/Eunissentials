import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/screens/splash.screen.dart';
import 'package:eunissentials/utils/cart.controller.dart';

void main() {
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }
}
