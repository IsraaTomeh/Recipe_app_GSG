import 'package:flutter/material.dart';
import 'package:food_recipe/provider/FavoriteProvider.dart';
import 'package:food_recipe/provider/recipes_provider.dart';
import 'package:food_recipe/screen/all_recipes_page.dart';
import 'package:food_recipe/screen/app.dart';
import 'package:food_recipe/screen/favoraites.dart';
import 'package:food_recipe/screen/home.dart';
import 'package:food_recipe/screen/login.dart';
import 'package:food_recipe/screen/profile.dart';
import 'package:food_recipe/screen/signup.dart';
import 'package:food_recipe/screen/start.dart';
import 'package:food_recipe/widgtes/favorite.dart';
import 'package:food_recipe/widgtes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipesProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider()..loadFavorites(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Recipe App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 91, 192, 186),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Start(),
      routes: {
        Routes.app: (context) => App(),
        Routes.start: (context) => Start(),
        Routes.login: (context) => Login(),
        Routes.signup: (context) => Signup(),
        Routes.home: (context) => Home(),
        Routes.profile: (context) => Profile(),
        Routes.favorites: (context) => FavoritesPage(),
        Routes.allRecipes: (context) => AllRecipesPage(),
      },
    );
  }
}
