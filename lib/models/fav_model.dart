class FavModel {
  int fav;

  FavModel({required this.fav});

  factory FavModel.fromMap({required Map data}) {
    return FavModel(fav: data['fav']);
  }
}
