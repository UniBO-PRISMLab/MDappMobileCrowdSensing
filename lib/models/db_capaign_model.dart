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
    print("DEBUG:::::: dentro al db ci sono: \n${(await campaigns()).length} campagne");

  }

  Future<List<Campaign>> campaigns() async {
    final db = await _initDb();
    final List<Map<String, dynamic>> maps = await db.query('campaign');

    return List.generate(maps.length, (i) {
      return Campaign(
        maps[i]['title'],
        maps[i]['lat'],
        maps[i]['lng'],
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
    print("DEBUG:::::: dentro al db ci sono: \n${(await campaigns()).length} campagne");

  }
}

class Campaign {
  final String address;
  final String? title, lat, lng;

  const Campaign(
      this.title,
      this.lat,
      this.lng,
      {
        required this.address,
      }
  );

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