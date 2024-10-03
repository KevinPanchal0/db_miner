import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:db_miner/utils/helpers/db_helper.dart';
import 'package:db_miner/views/pages/all_quotes_page.dart';
import 'package:db_miner/views/pages/category_page.dart';
import 'package:db_miner/views/pages/favorite_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotchBottomBarController notchBottomBarController =
      NotchBottomBarController();

  PageController pageController = PageController();
  loadDB() async {
    await DbHelper.dbHelper.initDB();
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
          AllQuotesPage(),
          CategoryPage(),
          FavoritePage(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: notchBottomBarController,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Image.asset('assets/images/inactive_quote_icon.png'),
            activeItem: Image.asset('assets/images/active_quote_icon.png'),
            itemLabel: 'All Quotes(Json)',
          ),
          const BottomBarItem(
            inActiveItem: Icon(
              Icons.category_outlined,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.category,
              color: Colors.black,
            ),
            itemLabel: 'Category(Api)',
          ),
          const BottomBarItem(
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
