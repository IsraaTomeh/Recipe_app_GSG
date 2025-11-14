import 'package:flutter/material.dart';
import 'package:food_recipe/provider/FavoriteProvider.dart';
import 'package:provider/provider.dart';
import 'package:food_recipe/model/recipe_model.dart';

class Favorite extends StatefulWidget {
  final Recipe recipe;
  const Favorite({super.key, required this.recipe});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favoritesProvider.isFavorite(widget.recipe.id.toString());

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: IconButton(
          onPressed: () {
            setState(() {
              favoritesProvider.toggleFavorite(widget.recipe.id.toString());
            });
          },
          icon: isFav
              ? const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 76, 158, 132),
                )
              : const Icon(
                  Icons.favorite_border_outlined,
                  color: Color.fromARGB(255, 76, 158, 132),
                ),
        ),
      ),
    );
  }
}
