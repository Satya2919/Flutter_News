import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:news_final/api/news_api_org.dart';
import 'package:news_final/database/news_dao.dart';
import 'package:news_final/database/recent_dao.dart';
import 'package:news_final/models/news.dart';
import 'package:news_final/models/recent.dart';
import './bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final _newsDao = NewsDao();

  final _recentDao = RecentDao();

  @override
  NewsState get initialState => NewsLoading();

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is LoadNews) {
      yield* _loadNewsList(event.topic);
    } else if (event is DeleteAll) {
      await _newsDao.delete();
    }
  }

  Stream<NewsState> _loadNewsList(String topic) async* {
    List<News> newsList = await _newsDao.getNews(topic);
    if (newsList.length == 0) {
      yield NewsLoading();
      await _addNews(topic);
      newsList = await _newsDao.getNews(topic);
    }
    yield NewsLoaded(newsList);
  }

  Future _addNews(String topic) async {
    final NewsApi newsApi = NewsApi();
    List response = await newsApi.loadNews(topic);
    if (response == null) {
      return;
    }
    for (var data in response) {
      News news = News(
        topic: topic,
        author: data['author'],
        title: data['title'],
        description: data['description'],
        url: data['url'],
        urlToImage: data['urlToImage'],
        publishedAt: data['publishedAt'],
        content: data['content'],
      );
      await _newsDao.insert(news);
    }
    await _recentDao.insert(Recent(topic: topic));
  }
}
