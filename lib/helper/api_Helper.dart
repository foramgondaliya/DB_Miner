import 'dart:convert';
import 'package:budget_tracker_app/Model/ApiModel.dart';
import 'package:budget_tracker_app/Model/DataModel.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static ApiHelper apiHelper = ApiHelper._();

  fetchAPI() async {
    String URL = "https://dummyjson.com/quotes/";
    http.Response response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      Map decodedData = jsonDecode(response.body);
      List quotes = decodedData['quotes'];
      List mainData = quotes
          .map(
            (e) => ApiQuoteModel.fromMap(data: e),
          )
          .toList();

      return mainData;
    }
  }

  fetchRandomQuote() async {
    String URL = "https://dummyjson.com/quotes/random";
    http.Response response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      Map decodedData = jsonDecode(response.body);
      Quote randomQuote = Quote.fromMap(
        data: decodedData,
      );
      return randomQuote;
    }
  }
}
