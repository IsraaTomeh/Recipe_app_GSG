import 'package:flutter/material.dart';
import 'package:food_recipe/Db/dataBaseHelper.dart';
import 'package:provider/provider.dart';
import 'package:food_recipe/widgtes/card1.dart';
import 'package:food_recipe/widgtes/card2.dart';
import 'package:food_recipe/widgtes/card3.dart';
import 'package:food_recipe/provider/recipes_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  String? name;
  String? email;
  getUser() async {
    //print(1111);
    final db = DatabaseHelper();
    final currentUser = await db.getCurrentUser();

    if (currentUser != null) {
      setState(() {
        name = currentUser['name'] ?? '1234';
        email = currentUser['email'] ?? '12345';
      });

      print(currentUser['name']);
      print(currentUser['email']);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    if (!recipesProvider.isLoading && recipesProvider.recipes.isEmpty) {
      Future.microtask(() => recipesProvider.fetchRecipes());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: FutureBuilder<Map<String, String>?>(
          future: DatabaseHelper().getCurrentUser(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 76, 158, 132),
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  name ?? 'Guest',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/person.png'),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(context),
      body: recipesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Card1(image: 'assets/explore1.png'),
                    const SizedBox(height: 20),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recipesProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = recipesProvider.categories[index];
                          return Card2(text: category, onTap: () {});
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Text(
                          'Popular Recipes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/allRecipes');
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Color.fromARGB(255, 76, 158, 132),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipesProvider.recipes.length >= 6
                          ? 6
                          : recipesProvider.recipes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        final recipe = recipesProvider.recipes[index];
                        return Card3(recipe: recipe);
                      },
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, String>?>(
        future: DatabaseHelper().getCurrentUser(),
        builder: (context, snapshot) {
          return Column(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/person.png'),
                      backgroundColor: Color.fromARGB(255, 131, 194, 174),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name ?? 'Guest',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 76, 158, 132),
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 76, 158, 132),
                ),
                title: const Text(
                  'Favorites',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/favoraites');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 76, 158, 132),
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),

              SizedBox(height: 100),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 76, 158, 132),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  DatabaseHelper().clearCurrentUser();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
