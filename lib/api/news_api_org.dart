import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApi {
  String baseUrl =
      "https://newsapi.org/v2/everything?apiKey=390cac380a9949abbb4b2e57812c0c72&pageSize=100";

  Future<List> loadNews(String topic) async {
    final String url = baseUrl + '&q=$topic';
    try {
      http.Response response = await http.get(url);
      const JsonDecoder decoder = const JsonDecoder();
      //we need only articles
      return decoder.convert(response.body)['articles'];
    } on Exception catch (_) {
      return null;
    }
  }
}
