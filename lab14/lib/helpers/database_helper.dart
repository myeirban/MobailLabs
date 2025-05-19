import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
/*DatabaseHelper class ni ogogdliin santai ajillahad zoriulsan
* singleton class bogood ogogdliin san uusgeh,unshih,hadgalah,ustgah(save,read,update,delete uildel hiideg)
* zereg uildluudiig hiideg
* Singleton zagvariig ashiglasan shaltgaan ni app dotroo davhar davhar uusgehees sergiilj
* negdsen ogogdliin sangiin udirdlagiig hangahiin tuld singleton zagvariig ashigladag*/
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;//

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();/*app-iin hadgalah zovshoorogdson dotood
    sangiin zamiig zaaj ogdog.SQLite sang terhuu dotood zamd uusgehiin tuld herglej bn*/
    String path = join(documentsDirectory.path, 'places.db');/*path_provider oos avsan direktoriin zamd
     place.db failiin neriig nemj neriig nemj buren zam uusgej bn.*/
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
/*places nertei husnegt id anhdagch tulhuur(INT avtomataar osdog),
* title hooson baij bolohgui
* zurag hooson baij bolohgui
* bairshil hooson baij bolohgui
* tailbar zaaval bish*/
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE places(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        image TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT
      )
    ''');
  }

  //shine gazriin medeelliig places husnegted nemne.
  Future<int> insertPlace(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('places', row);
  }

  //places husnegted baigaa buh moriig jagsaaj,List<Map> helbereer butsaana.
  Future<List<Map<String, dynamic>>> getPlaces() async {
    Database db = await database;
    return await db.query('places');
  }

  //id aar haij tohiroh gants gazriig butsaadag,hereb oldohgui bol null butsaadag.
  Future<Map<String, dynamic>?> getPlace(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'places',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  //id aar ni ogogdson gazriin medeelliig places husnegtees ustgana.
  Future<int> deletePlace(int id) async {
    Database db = await database;
    return await db.delete(
      'places',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ogogdliin sand hadgalagdsan zovhon neg gazriin zamiig shinecildeg
  Future<int> updatePlaceImage(int id, String imagePath) async {
    Database db = await database;
    return await db.update(
      'places',
      {'image': imagePath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 