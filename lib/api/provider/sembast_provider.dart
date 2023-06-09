import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastProvider extends ChangeNotifier {
  // DatabaseFactory dbFactory = databaseFactoryIo;
  DatabaseFactory dbFactory = kIsWeb ? databaseFactoryWeb : databaseFactoryIo;
  late Database _db;

  final store = intMapStoreFactory.store("note");
  static final SembastProvider _singleton = SembastProvider._internal();
  final List<NoteModel> _noteModel = [];
  List<NoteModel> get noteModel => _noteModel;

  SembastProvider._internal();

  factory SembastProvider() {
    return _singleton;
  }

  Future<Database> init() async {
    _db = await _openDb();

    return _db;
  }

  Future _openDb() async {
    var dbPath = "";
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        final docsDir = await getApplicationDocumentsDirectory();
        dbPath = join(docsDir.path, "note.db");
      } else {
        dbPath = join("note.db");
      }
    } else {
      dbPath = join("note.db");
    }

    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future<int> addNote(NoteModel notemodel) async {
    int id = await store.add(_db, notemodel.toMap());
    notifyListeners();
    return id;
  }

  Future getNotes(String filter) async {
    await init();
    final finder = Finder(
        filter: Filter.custom((record) => record['title']!
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase())),
        sortOrders: [SortOrder(Field.key, false)]);
    final snapshot = await store.find(_db, finder: finder);
    return snapshot.map((item) {
      final pwd = NoteModel.fromMap(item.value);
      pwd.id = item.key;

      return pwd;
    }).toList();
  }

  Future updateNotes(NoteModel nm) async {
    final finder = Finder(filter: Filter.byKey(nm.id));
    await store.update(_db, nm.toMap(), finder: finder);
    notifyListeners();
  }

  Future searchNotes(NoteModel nm) async {
    final finder = Finder(filter: Filter.byKey(nm.id));
    await store.update(_db, nm.toMap(), finder: finder);
    notifyListeners();
  }

  Future deleteNote(NoteModel nm) async {
    final finder = Finder(filter: Filter.byKey(nm.id));
    await store.delete(_db, finder: finder);
    //notifyListeners();
  }

  Future deleteAll() async {
    await store.delete(_db);
    notifyListeners();
  }
}
