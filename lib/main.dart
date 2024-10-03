import 'package:db_miner/views/pages/home_page.dart';
import 'package:db_miner/views/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isIntroScreenVisited = prefs.getBool("isIntroPageVisited") ?? false;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: (isIntroScreenVisited) ? '/' : '/intro_page',
      getPages: [
        GetPage(name: '/intro_page', page: () => const IntroPage()),
        GetPage(name: '/', page: () => const HomePage()),
      ],
    ),
  );
}
