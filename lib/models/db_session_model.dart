import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbSessionModel {

  static final DbSessionModel _instance = DbSessionModel._internal();

  Database? _db;

  DbSessionModel._internal() {
    _initDb();
  }

  factory DbSessionModel() {
    return _instance;
  }

  Future<Database> _initDb() async {
    _db ??= await openDatabase(join(await getDatabasesPath(), 'session.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE session('
              'account TEXT PRIMARY KEY,'
              ' chainId INTEGER,'
              ' uri TEXT'
              ')',
        );
      },
      version: 1,
    );
    return _db!;
  }

  Future<void> insertSession(Session cmp) async {
    final db = await _initDb();
    // `conflictAlgorithm` to use in case the same campaign is inserted twice.
    await db.insert(
      'session',
      cmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Session>> sessions() async {
    final db = await _initDb();
    final List<Map<String, dynamic>> maps = await db.query('session');

    return List.generate(maps.length, (i) {
      return Session(
        account: maps[i]['account'],
        chainId: maps[i]['chainId'],
        uri: maps[i]['uri'],
      );
    });
  }

  Future<void> updateSession(Session cmp) async {
    final db = await _initDb();
    await db.update(
      'session',
      cmp.toMap(),
      where: 'account = ?',
      whereArgs: [cmp.account],
    );
  }

  Future<void> deleteSession(String account) async {
    final db = await _initDb();
    await db.delete(
      'session',
      where: 'account = ?',
      whereArgs: [account],
    );
  }

  Future<void> deleteAll() async {
    final db = await _initDb();
    await db.delete('session');
  }
}

class Session {
  final String account;
  final  int chainId;
  final String uri;

  const Session(
      {
        required this.account,
        required this.chainId,
        required this.uri,
      }
      );

  Map<String, dynamic> toMap() {
    return {
      'account': account,
      'chainId': chainId,
      'uri': uri,
    };
  }

  @override
  String toString() {
    return 'Session{account: $account, chainId: $chainId, uri: $uri}';
  }

}