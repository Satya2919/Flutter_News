import 'package:sembast/sembast.dart';
import 'package:news_final/database/app_database.dart';
import 'package:news_final/models/recent.dart';

class RecentDao {
  // ? Get Database
  Future<Database> get _db async => AppDatabase.instance.database;

  // ? Recent Collection
  static const String Recent_STORE_NAME = 'recent';
  final _recentStore = intMapStoreFactory.store(Recent_STORE_NAME);

  // ? Insertion
  Future insert(Recent recent) async {
    await _recentStore.add(await _db, recent.toMap());
  }

  // ? Get All Recent
  Future<List<Recent>> getAllRecent() async {
    Finder finder = Finder(
      sortOrders: [
        SortOrder('id', false) // ? decending order
      ],
    );
    List<RecordSnapshot<int, Map<String, dynamic>>> recordSnapshot =
        await _recentStore.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot) {
      Recent recent = Recent.fromMap(snapshot.value);
      recent.id = snapshot.key;
      return recent;
    }).toList();
  }
}
