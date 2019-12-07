import 'package:meta/meta.dart';


@immutable
abstract class NewsEvent {}

class LoadNews extends NewsEvent {
  final String topic;
  LoadNews(this.topic);
}

class DeleteAll extends NewsEvent {}
