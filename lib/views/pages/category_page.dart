import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:db_miner/models/quotes_model_api.dart';
import 'package:db_miner/utils/helpers/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../utils/constanst/image_list_constant.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RxInt? isSelected = 1.obs;
  final AppinioSwiperController controller = AppinioSwiperController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: ApiHelper.apiHelper.fetchQuotesApi(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<QuotesModelApi>? quotes = snapshot.data;

          return Center(
            child: SizedBox(
              height: 650,
              width: 400,
              child: AppinioSwiper(
                controller: controller,
                isDisabled: false,
                loop: true,
                backgroundCardOffset: const Offset(51, 50),
                backgroundCardScale: 0.0,
                swipeOptions: const SwipeOptions.symmetric(horizontal: true),
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton.filled(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite_border_outlined,
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
                                  fontSize: 25, color: Colors.white),
                            ),
                            Text(
                              '- ${quotes[i].author.toUpperCase()}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              quotes[i].category.isEmpty
                                  ? '- random'
                                  : '- ${quotes[i].category[0]}',
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
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
