class QuotesModelApi {
  int quoteId;
  String quote;
  String author;
  List category;
  int fav;

  QuotesModelApi(
      {required this.quoteId,
      required this.quote,
      required this.author,
      required this.category,
      required this.fav});

  factory QuotesModelApi.fromMap({required Map data}) {
    return QuotesModelApi(
      quoteId: data['id'],
      quote: data['body'],
      author: data['author'],
      category: data['tags'],
      fav: data['favorites_count'],
    );
  }
}
