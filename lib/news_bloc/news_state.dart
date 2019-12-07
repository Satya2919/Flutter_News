import 'package:meta/meta.dart';
import 'package:news_final/models/news.dart';

@immutable
abstract class NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> newsList;
  NewsLoaded(this.newsList);
}
