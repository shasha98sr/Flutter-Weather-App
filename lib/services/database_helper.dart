import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const table = 'weather';

  static const columnId = '_id';
  static const columnCityName = 'city_name';
  static const columnTemp = 'temp';
  static const columnTempMin = 'temp_min';
  static const columnTempMax = 'temp_max';
  static const columnHumidity = 'humidity';
  static const columnRain = 'Rain';


  // DatabaseHelper._privateConstructor();
  //
  // static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._internal();


  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "weather.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnCityName TEXT NOT NULL,
            $columnTemp TEXT NOT NULL,
            $columnTempMax TEXT NOT NULL,
            $columnTempMin TEXT NOT NULL,
            $columnHumidity TEXT NOT NULL,
            $columnRain TEXT NOT NULL);
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List> getAllRecords(String dbTable) async {
    var dbClient = await instance.database;
    var result = await dbClient.rawQuery("SELECT * FROM $dbTable");

    return result.toList();
  }
}