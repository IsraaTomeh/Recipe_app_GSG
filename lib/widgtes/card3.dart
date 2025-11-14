import 'package:flutter/material.dart';
import 'package:food_recipe/model/recipe_model.dart';
import 'package:food_recipe/widgtes/favorite.dart';
import 'package:food_recipe/widgtes/recipe_details.dart';

class Card3 extends StatelessWidget {
  const Card3({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeScreen(recipe: recipe)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(88, 219, 220, 220),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(recipe.image, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    recipe.cuisine,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: const Color.fromARGB(255, 76, 158, 132),
                        size: 18,
                      ),
                      Text(recipe.rating.toString()),
                      Spacer(),
                      Favorite(recipe: recipe),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
