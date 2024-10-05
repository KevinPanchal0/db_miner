import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:db_miner/utils/constanst/image_list_constant.dart';
import 'package:flutter/material.dart';

import '../../models/quotes_model_json.dart';
import '../../utils/helpers/db_helper.dart';

class OfflineQuotesPage extends StatefulWidget {
  const OfflineQuotesPage({super.key});

  @override
  State<OfflineQuotesPage> createState() => _OfflineQuotesPageState();
}

class _OfflineQuotesPageState extends State<OfflineQuotesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final AppinioSwiperController controller = AppinioSwiperController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: DbHelper.dbHelper.fetchQuotes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<QuotesModelJson>? quotes = snapshot.data;

          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 700,
                  width: 400,
                  child: AppinioSwiper(
                    controller: controller,
                    isDisabled: false,
                    loop: true,
                    backgroundCardOffset: const Offset(51, 50),
                    backgroundCardScale: 0.0,
                    swipeOptions:
                        const SwipeOptions.symmetric(horizontal: true),
                    allowUnSwipe: true,
                    onCardPositionChanged: (position) {},
                    allowUnlimitedUnSwipe: true,
                    cardBuilder: (context, i) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.black54, BlendMode.color),
                            child: Image.asset(
                              predefinedImageList[i],
                              fit: BoxFit.cover,
                              height: 800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton.filled(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  textAlign: TextAlign.center,
                                  quotes[i].quote,
                                  style: const TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                                Text(
                                  '- ${quotes[i].author}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  '- ${quotes[i].category}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    cardCount: quotes!.length,
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
