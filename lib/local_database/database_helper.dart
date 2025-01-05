import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'observations_data.db');
    print("Database path: $path"); // Log the database path
    return await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: (db, version) async {
        print("Creating the database table"); // Log table creation
        await db.execute('''
          CREATE TABLE observations_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            time TEXT,
            turbidity TEXT,
            spm TEXT,
            chlorophyll TEXT,
            latitude REAL,
            longitude REAL,
            ref_red REAL,
            ref_green REAL,
            ref_blue REAL,
            temperature REAL,      
            ph_value REAL,        
            water_depth REAL,     
            dissolved_O2 REAL,
            secchi_depth REAL     
          )
        ''');
      },
    );
  }

  Future<void> insertObservation(Map<String, dynamic> observation) async {
    final db = await database;
    await db.insert('observations_data', observation);
  }

  Future<int> deleteObservation(int id) async {
    final db = await database;
    return await db.delete(
      'observations_data', // Make sure to use the correct table name here
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'observations_data.db');

    File databaseFile = File(path);
    if (await databaseFile.exists()) {
      await databaseFile.delete();
      print('Database deleted successfully');
    } else {
      print('Database does not exist');
    }
  }

  Future<List<Map<String, dynamic>>> fetchObservations() async {
    final db = await database;
    return await db.query('observations_data');
  }
}
