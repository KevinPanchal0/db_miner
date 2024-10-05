import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:db_miner/controllers/connectivity_controller.dart';
import 'package:db_miner/models/favorite_quote_model.dart';
import 'package:db_miner/models/quotes_model_api.dart';
import 'package:db_miner/utils/helpers/api_helper.dart';
import 'package:db_miner/utils/helpers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constanst/image_list_constant.dart';

class OnlineQuotesPage extends StatefulWidget {
  const OnlineQuotesPage({super.key});

  @override
  State<OnlineQuotesPage> createState() => _OnlineQuotesPageState();
}

class _OnlineQuotesPageState extends State<OnlineQuotesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RxInt? isSelected = 1.obs;
  final AppinioSwiperController controller = AppinioSwiperController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  ConnectivityController connectivityController = Get.find();
  @override
  void initState() {
    super.initState();
    connectivityController.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        return await Future.delayed(const Duration(seconds: 2), () {
          connectivityController.checkConnectivity();
          setState(() {});
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            (connectivityController.connectivityModal.isNetworkAvailable ==
                    false)
                ? Center(
                    child: Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animation/animation.json',
                            height: 150),
                        const Text('No Internet'),
                        const Text('Check Your Connectivity'),
                        OutlinedButton(
                          onPressed: () {
                            refreshIndicatorKey.currentState?.show();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ))
                : FutureBuilder(
                    future: ApiHelper.apiHelper.fetchQuotesApi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        List<QuotesModelApi>? quotes = snapshot.data;

                        List random = ['random'];
                        return (quotes!.isEmpty)
                            ? const Center(
                                child: Text('No Quotes, Pull to refresh'),
                              )
                            : Center(
                                child: SizedBox(
                                  height: 700,
                                  width: 400,
                                  child: AppinioSwiper(
                                    controller: controller,
                                    isDisabled: false,
                                    loop: true,
                                    backgroundCardOffset: const Offset(51, 50),
                                    backgroundCardScale: 0.0,
                                    swipeOptions: const SwipeOptions.symmetric(
                                        horizontal: true),
                                    allowUnSwipe: true,
                                    onCardPositionChanged: (position) {},
                                    allowUnlimitedUnSwipe: true,
                                    cardBuilder: (context, i) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                                Colors.black54,
                                                BlendMode.color),
                                            child: Image.asset(
                                              (i % 2 == 0)
                                                  ? predefinedImageList[7]
                                                  : predefinedImageList[15],
                                              fit: BoxFit.cover,
                                              height: 800,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton.filled(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    IconButton.filled(
                                                      onPressed: () async {
                                                        FavoriteQuoteModel
                                                            favModel =
                                                            FavoriteQuoteModel(
                                                          id: quotes[i].quoteId,
                                                          quote:
                                                              quotes[i].quote,
                                                          author:
                                                              quotes[i].author,
                                                          category: (quotes[i]
                                                                  .category
                                                                  .isEmpty)
                                                              ? random[0]
                                                              : quotes[i]
                                                                  .category[0],
                                                        );
                                                        int res = await DbHelper
                                                            .dbHelper
                                                            .addFav(
                                                                favModel:
                                                                    favModel);
                                                        print(res);
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  quotes[i].quote,
                                                  style: const TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  '- ${quotes[i].author.toUpperCase()}',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  quotes[i].category.isEmpty
                                                      ? '- random'
                                                      : '- ${quotes[i].category[0]}',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    cardCount: quotes.length,
                                  ),
                                ),
                              );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
