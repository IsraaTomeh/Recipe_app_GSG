import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_recipe/provider/recipes_provider.dart';
import 'package:food_recipe/widgtes/card3.dart';

class AllRecipesPage extends StatelessWidget {
  const AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    if (!recipesProvider.isLoading && recipesProvider.recipes.isEmpty) {
      Future.microtask(() => recipesProvider.fetchRecipes());
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Row(
          children: [
            Text(
              'All ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 76, 158, 132),
                fontSize: 40,
              ),
            ),
            Text(
              'Recipes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      body: recipesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: recipesProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = recipesProvider.categories[index];
                      final isSelected =
                          recipesProvider.selectedCategory == category;

                      return GestureDetector(
                        onTap: () => recipesProvider.filterByCategory(category),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(255, 76, 158, 132)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color.fromARGB(255, 76, 158, 132),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 15,

                                color: isSelected
                                    ? Colors.white
                                    : const Color.fromARGB(255, 76, 158, 132),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: recipesProvider.recipe.isEmpty
                      ? const Center(
                          child: Text(
                            'No recipes found ',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: recipesProvider.recipe.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.68,
                              ),
                          itemBuilder: (context, index) {
                            final recipe = recipesProvider.recipe[index];
                            return Card3(recipe: recipe);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
