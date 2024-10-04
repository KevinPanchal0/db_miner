import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:db_miner/controllers/connectivity_controller.dart';
import 'package:db_miner/utils/helpers/db_helper.dart';
import 'package:db_miner/views/pages/offline_quote_page.dart';
import 'package:db_miner/views/pages/online_quote_page.dart';
import 'package:db_miner/views/pages/favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotchBottomBarController notchBottomBarController =
      NotchBottomBarController();

  PageController pageController = PageController();
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  loadDB() async {
    await DbHelper.dbHelper.initDB();
    connectivityController.checkConnectivity();
  }

  @override
  void initState() {
    super.initState();
    loadDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        title: const Text('Quotes'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: 500,
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          OfflineQuotesPage(),
          OnlineQuotesPage(),
          FavoritePage(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: notchBottomBarController,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.wifi_off,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.wifi_off,
              color: Colors.blueGrey,
            ),
            itemLabel: 'Offline',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.wifi,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.wifi,
              color: Colors.black,
            ),
            itemLabel: 'Online',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.favorite_border_outlined,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            itemLabel: 'Favorite',
          ),
        ],
        durationInMilliSeconds: 100,
        blurOpacity: 25,
        notchColor: Colors.grey.shade300,
        onTap: (val) {
          pageController.animateToPage(
            val,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        kBottomRadius: 25,
        kIconSize: 25,
      ),
    );
  }
}
