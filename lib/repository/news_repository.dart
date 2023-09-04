import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String channelName) async {

    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=c203e7ac51084c8aa29717b46eb222b5';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);

      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }





  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {

    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=c203e7ac51084c8aa29717b46eb222b5';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);

      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }



}
