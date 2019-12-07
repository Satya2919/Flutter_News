import 'package:sembast/sembast.dart';
import 'package:news_final/database/app_database.dart';
import 'package:news_final/models/news.dart';

class NewsDao {
  // ? Get Database
  Future<Database> get _db async => AppDatabase.instance.database;

  // ? News Collection
  static const String NEWS_STORE_NAME = 'news';
  final _newsStore = intMapStoreFactory.store(NEWS_STORE_NAME);

  // ? Insertion
  Future insert(News news) async {
    await _newsStore.add(await _db, news.toMap());
  }

  // ? Get All News
  Future<List<News>> getAllNews() async {
    List<RecordSnapshot<int, Map<String, dynamic>>> recordSnapshot =
        await _newsStore.find(await _db);
    return recordSnapshot.map((snapshot) {
      News news = News.fromMap(snapshot.value);
      news.id = snapshot.key;
      return news;
    }).toList();
  }

  // ? Get Selected News
  Future<List<News>> getNews(String topic) async {
    Finder finder = Finder(filter: Filter.equals('topic', topic));
    List<RecordSnapshot<int, Map<String, dynamic>>> recordSnapshot =
        await _newsStore.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot) {
      News news = News.fromMap(snapshot.value);
      news.id = snapshot.key;
      return news;
    }).toList();
  }

  Future delete() async {
    await _newsStore.delete(await _db);
  }
}
