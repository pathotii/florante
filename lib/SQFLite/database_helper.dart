import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../database_table/user_details.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createUserDetailsTable(db);
      },
    );
  }

  Future<void> createUserDetailsTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_details (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name TEXT,
          last_name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          user_type TEXT CHECK(user_type IN ('Teacher', 'Student')) NOT NULL DEFAULT 'Student'
        )
      ''');
      print('user_details table created or already exists.');
    } catch (e) {
      print('Error creating user_details table: $e');
    }
  }

  Future<void> insertUserDetails(UserDetails userDetails) async {
    final db = await database;
    try {
      await db.insert(
        'user_details',
        {
          'first_name': userDetails.firstName,
          'last_name': userDetails.lastName,
          'email': userDetails.email,
          'password': userDetails.password,
          'user_type': userDetails.userType,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('User details inserted successfully.');
    } catch (e) {
      print('Error inserting user details: $e');
    }
  }

  Future<List<UserDetails>> users() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_details');

    return List.generate(maps.length, (i) {
      return UserDetails.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> users = await db.query('user_details');
      return users;
    } catch (e) {
      print('Error fetching user details: $e');
      return [];
    }
  }

  Future<UserDetails?> getUserByEmail(String email) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query(
        'user_details',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        return UserDetails.fromMap(maps.first);
      }
    } catch (e) {
      print('Error retrieving user by email: $e');
      return null; 
    }
    return null;
  }
}
