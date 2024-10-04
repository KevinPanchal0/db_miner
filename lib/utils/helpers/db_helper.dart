import 'dart:convert';
import 'dart:developer';

import 'package:db_miner/models/quotes_model_json.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper dbHelper = DbHelper._();
  Database? database;
  initDB() async {
    String directoryPath = await getDatabasesPath();
    String path = join(directoryPath, "quotes.db");

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        String queryQuotes = """
        CREATE TABLE IF NOT EXISTS quotes(
quote_id INTEGER PRIMARY KEY AUTOINCREMENT, 
quote TEXT NOT NULL, 
author TEXT NOT NULL,
category TEXT,
fav INTEGER DEFAULT 0
        ); 
        """;

        String queryFav = """
        CREATE TABLE IF NOT EXISTS fav(
fav INTEGER PRIMARY KEY); 
        """;

        await database.execute(queryQuotes);
        await database.execute(queryFav);

        log('=================');
        log('Success');
        log('=================');
      },
    );
  }

  Future<int> addQuotes({required QuotesModelJson quotesModelJson}) async {
    await initDB();

    String query =
        'INSERT INTO quotes(quote_id ,quote, author, category, fav) VALUES(?, ?, ?, ?, ?);';
    List args = [
      quotesModelJson.quoteId,
      quotesModelJson.quote,
      quotesModelJson.author,
      quotesModelJson.category,
      quotesModelJson.fav
    ];

    int res = await database!.rawInsert(query, args);

    log('$res');
    return res;
  }

  Future<void> loadQuotes() async {
    String jsonData =
        await rootBundle.loadString('assets/json/local_quotes.json');
    Map jsonMap = jsonDecode(jsonData);
    List jsonList = jsonMap['quotes'];

    jsonList.forEach(
      (quote) async {
        await addQuotes(
          quotesModelJson: QuotesModelJson.fromMap(data: quote),
        );
      },
    );
  }

  Future<List<QuotesModelJson>> fetchQuotes() async {
    await initDB();
    String query = 'SELECT * FROM quotes;';
    List<Map<String, dynamic>> allRecords = await database!.rawQuery(query);

    List<QuotesModelJson> quotesModel =
        allRecords.map((e) => QuotesModelJson.fromMap(data: e)).toList();

    return quotesModel;
  }
}
