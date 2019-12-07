import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // ? Singleton Instance
  static final AppDatabase _singleton = AppDatabase._();
  // ? Private Constructor
  AppDatabase._();
  // ? Singleton Getter
  static AppDatabase get instance => _singleton;

  Completer<Database> _dbOpenCompleter;

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDirectory.path, 'app.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter.complete(database);
  }
}
