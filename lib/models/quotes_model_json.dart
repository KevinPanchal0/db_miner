class QuotesModelJson {
  int? quoteId;
  String quote;
  String author;
  String category;
  int fav;

  QuotesModelJson({
    this.quoteId,
    required this.quote,
    required this.author,
    required this.category,
    required this.fav,
  });

  factory QuotesModelJson.fromMap({required Map<String, dynamic> data}) {
    return QuotesModelJson(
      quoteId: data['quote_id'],
      quote: data['quote'],
      author: data['author'],
      category: data['category'],
      fav: data['fav'],
    );
  }
}
