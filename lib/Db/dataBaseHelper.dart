import 'package:food_recipe/provider/FavoriteProvider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            mealId TEXT,
            FOREIGN KEY(userId) REFERENCES users(id)
          )
        ''');
      },
    );
  }

  Future<int> insertUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final db = await database;
    return await db.insert('users', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<bool> checkEmailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<void> addFavorite(int userId, String mealId) async {
    final db = await database;
    await db.insert('favorites', {
      'userId': userId,
      'mealId': mealId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(int userId, String mealId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'userId = ? AND mealId = ?',
      whereArgs: [userId, mealId],
    );
  }

  Future<Set<String>> getFavorites(int userId) async {
    print(userId);
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.map((e) => e['mealId'].toString()).toSet();
  }

  Future<void> saveCurrentUser(
    String firstName,
    String lastName,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
  }

  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');

    if (email != null && firstName != null && lastName != null) {
      return {'name': "$firstName $lastName", 'email': email};
    }
    return null;
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('email');
    final favoriteProvider = FavoriteProvider();
    await favoriteProvider.loadFavorites();
  }
}
//