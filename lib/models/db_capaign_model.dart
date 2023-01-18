import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbCampaignModel {

  static final DbCampaignModel _instance = DbCampaignModel._internal();

  Database? _db;

  DbCampaignModel._internal() {
    _initDb();
  }

  factory DbCampaignModel() {
    return _instance;
  }

  Future<Database> _initDb() async {
    _db ??= await openDatabase(join(await getDatabasesPath(), 'campaigns.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE campaign('
                'address TEXT PRIMARY KEY,'
                ' title TEXT,'
                ' lat TEXT,'
                ' lng TEXT)',
          );
        },
        version: 1,
      );
    return _db!;
  }

  Future<void> insertCampaign(Campaign cmp) async {
    final db = await _initDb();
    // `conflictAlgorithm` to use in case the same campaign is inserted twice.
    await db.insert(
      'campaign',
      cmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Campaign>> campaigns() async {
    final db = await _initDb();
    final List<Map<String, dynamic>> maps = await db.query('campaign');

    return List.generate(maps.length, (i) {
      return Campaign(
        address: maps[i]['address'],
        title: maps[i]['title'],
        lat: maps[i]['lat'],
        lng: maps[i]['lng'],
      );
    });
  }

  Future<void> updateCampaign(Campaign cmp) async {
    final db = await _initDb();
    await db.update(
      'campaign',
      cmp.toMap(),
      where: 'address = ?',
      whereArgs: [cmp.address],
    );
  }

  Future<void> deleteCampaign(String address) async {
    final db = await _initDb();
    await db.delete(
      'campaign',
      where: 'address = ?',
      whereArgs: [address],
    );
  }
}

class Campaign {
  final String address, title, lat, lng;

  const Campaign({
    required this.address,
    required this.title,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'title': title,
      'lat': lat,
      'lng': lng
    };
  }

  @override
  String toString() {
    return 'Campaign{address: $address, name: $title, lat: $lat, lng: $lng}';
  }

}