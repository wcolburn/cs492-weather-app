import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'package:weatherapp/scripts/location.dart' as location;

const dbName = 'location.db';
const sqlCreateTable = 'assets/sql/create.sql';
const sqlInsert = 'assets/sql/insert.sql';
const sqlGetAll = 'assets/sql/get_all.sql';
const sqlDelete = 'assets/sql/delete.sql';

class LocationDatabase {
  final Database _db;

  LocationDatabase({required Database db}) : _db = db;

  static Future<LocationDatabase> open() async {
    final Database db = await openDatabase(dbName, version: 1, 
      onCreate: (Database db, int version) async {
        String query = await rootBundle.loadString(sqlCreateTable);
        await db.execute(query);
      });

      return LocationDatabase(db: db);
  }

  void close() async {
    await _db.close();
  }

  Future<List<location.Location>> getLocations() async {
    String query = await rootBundle.loadString(sqlGetAll);
    List<Map> locationEntries = await _db.rawQuery(query);
    return locationEntries.map((entry) => location.Location.fromJson(Map<String, dynamic>.from(entry))).toList();
  }

  void insertLocation(location.Location location) async {
    String query = await rootBundle.loadString(sqlInsert);

    _db.transaction((txn) async {
      await txn.rawInsert(query, [location.city, location.state, location.zip, location.latitude, location.longitude]);
    });
  }

  void deleteLocation(location.Location location) async {
    String query = await rootBundle.loadString(sqlDelete);
    _db.transaction((txn) async {
      await txn.rawDelete(query, [location.city, location.state, location.zip, location.latitude, location.longitude]);
    });
  }
}