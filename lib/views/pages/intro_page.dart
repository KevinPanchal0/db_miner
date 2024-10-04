import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/helpers/db_helper.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Future<void> checkPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isIntroPageVisited", true);
  }

  loadDB() async {
    await DbHelper.dbHelper.initDB();
    await DbHelper.dbHelper.loadQuotes();
  }

  @override
  void initState() {
    super.initState();

    loadDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/quote_icon.jpeg',
              height: 250,
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.quora),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
              ),
              onPressed: () async {
                await checkPrefs();
                Get.offAllNamed('/');
              },
              label: const Text('Get Started'),
            ),
            const Text("Made with ❤️ in India"),
          ],
        ),
      ),
    );
  }
}
