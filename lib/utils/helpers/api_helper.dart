import 'dart:convert';
import 'dart:developer';
import 'package:db_miner/models/quotes_model_api.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static final ApiHelper apiHelper = ApiHelper._();

  Future<List<QuotesModelApi>?> fetchQuotesApi() async {
    String favQsApi = 'https://favqs.com/api/quotes';
    final response = await http.get(
      Uri.parse(favQsApi),
      headers: {
        'Authorization': 'Token token=401de41444261d62ab909d51e2ed9064',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List quotesList = await data['quotes'];
      List<QuotesModelApi> quotesModal =
          quotesList.map((e) => QuotesModelApi.fromMap(data: e)).toList();
      log(quotesModal[0].quote);

      return quotesModal;
    } else {
      log('Failed to fetch quotes: ${response.statusCode}');
      List<QuotesModelApi> quotesModal = [];
      return quotesModal;
    }
  }

  Future<Map<String, dynamic>> fetchSingleQuotesApi({required int id}) async {
    String favQsApi = 'https://favqs.com/api/quotes/$id';
    final response = await http.get(
      Uri.parse(favQsApi),
      headers: {
        'Authorization': 'Token token=401de41444261d62ab909d51e2ed9064',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      Map<String, dynamic> quotesList = await data;

      return quotesList;
    } else {
      log('Failed to fetch quotes: ${response.statusCode}');
      Map<String, dynamic> quotesModal = {};
      return quotesModal['error'];
    }
  }
}
