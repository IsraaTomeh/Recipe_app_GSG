import 'package:flutter/foundation.dart';
import 'package:food_recipe/Db/dataBaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  static List<String> _favoriteMealIds = [];

  static List<String> get favoriteMealIds => _favoriteMealIds;

  Future<void> loadFavorites() async {
    String email;
    _favoriteMealIds = [];
    final db = DatabaseHelper();
    final currentUser = await db.getCurrentUser();

    if (currentUser != null && currentUser['email'] != null) {
      email = currentUser['email']!;
    } else {
      email = 'guest';
    }

    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favoriteMeals_$email') ?? [];
    _favoriteMealIds = favs;
    notifyListeners();
  }

  void toggleFavorite(String mealId) async {
    final db = DatabaseHelper();
    final currentUser = await db.getCurrentUser();
    final email = currentUser!['email'];
    print('$email $mealId ${currentUser!['email']}');
    if (_favoriteMealIds.contains(mealId)) {
      print(-1);
      _favoriteMealIds.remove(mealId);
    } else {
      print(_favoriteMealIds.length);
      _favoriteMealIds.add(mealId);
      print(_favoriteMealIds.length);
    }
    await saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final db = DatabaseHelper();
    final currentUser = await db.getCurrentUser();
    final email = currentUser!['email'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoriteMeals_$email',
      _favoriteMealIds.toList(),
    );
  }

  bool isFavorite(String mealId) => _favoriteMealIds.contains(mealId);
}
