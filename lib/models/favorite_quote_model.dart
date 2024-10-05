class FavoriteQuoteModel {
  int id;
  String quote;
  String author;
  String category;

  FavoriteQuoteModel({
    required this.id,
    required this.quote,
    required this.author,
    required this.category,
  });
  factory FavoriteQuoteModel.fromMap({required Map<String, dynamic> map}) {
    return FavoriteQuoteModel(
      id: map['id'],
      quote: map['body'],
      author: map['author'],
      category: (map['tags'].isBlank) ? 'random' : map['tags'].isBlank,
    );
  }
}
