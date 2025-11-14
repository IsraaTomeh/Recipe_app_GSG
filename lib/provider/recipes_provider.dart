import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:food_recipe/model/recipe_model.dart';

class RecipesProvider extends ChangeNotifier {
  List<Recipe> recipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = false;
  bool _isFetched = false;
  String _selectedCategory = 'All';

  List<Recipe> get recipe => _filteredRecipes;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  final List<String> categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
  ];

  Future<void> fetchRecipes() async {
    if (_isFetched) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/recipes?limit=50'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final recipesResponse = RecipeResponse.fromJson(data);
        recipes = recipesResponse.recipes;
        _filteredRecipes = recipes;
        _isFetched = true;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('❌ Error fetching recipes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;

    if (category == 'All') {
      _filteredRecipes = recipes;
    } else {
      _filteredRecipes = recipes
          .where(
            (r) => r.mealType.any(
              (type) => type.toLowerCase() == category.toLowerCase(),
            ),
          )
          .toList();
    }

    notifyListeners();
  }

  Recipe? getMeal(String id) {
    for (var x in recipes) {
      if (id == x.id.toString()) return x;
    }

    return null;
  }
}
