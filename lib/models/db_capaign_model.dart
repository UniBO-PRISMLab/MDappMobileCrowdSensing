import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../services/services_controllerV2.dart';

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
                ' lng TEXT,'
                ' radius TEXT)',
          );
        },
        version: 1,
      );
    return _db!;
  }

  Future<void> insertCampaign(Campaign cmp) async {
    final db = await _initDb();
    await db.insert(
      'campaign',
      cmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    ServicesControllerV2.resetService();
  }

  Future<List<Campaign>> campaigns() async {
    final db = await _initDb();
    final List<Map<String, dynamic>> maps = await db.query('campaign');

    return List.generate(maps.length, (i) {
      return Campaign(
        title: maps[i]['title'],
        lat: maps[i]['lat'],
        lng: maps[i]['lng'],
        radius: maps[i]['radius'],
        address: maps[i]['address'],
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
    ServicesControllerV2.resetService();
  }
}

class Campaign {
  final String address, title, lat, lng, radius;

  const Campaign(
      {
        required this.title,
        required this.lat,
        required this.lng,
        required this.radius,
        required this.address,
      }
  );

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'title': title,
      'lat': lat,
      'lng': lng,
      'radius': radius,
    };
  }

  @override
  String toString() {
    return 'Campaign{address: $address, name: $title, lat: $lat, lng: $lng, radius: $radius}';
  }

}