import 'package:flutter/material.dart';
import 'package:food_recipe/provider/FavoriteProvider.dart';
import 'package:food_recipe/Db/dataBaseHelper.dart';
import 'package:food_recipe/widgtes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final prefs = SharedPreferences.getInstance();
  String? name;
  String? email;
  Future<void> logout(BuildContext context) async {
    final favoriteProvider = FavoriteProvider();
    await favoriteProvider.saveFavorites();
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  getUser() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'My ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 76, 158, 132),
                fontSize: 36,
              ),
            ),
            Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/person.png'),
              backgroundColor: const Color.fromARGB(255, 150, 208, 189),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(166, 245, 245, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            'Personal info',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 2, 0, 0),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 76, 158, 132),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: const Color.fromARGB(255, 76, 158, 132),
                        size: 30,
                      ),
                      subtitle: Text('Name'),
                      title: Text(
                        '$name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.email,
                        color: const Color.fromARGB(255, 76, 158, 132),
                        size: 30,
                      ),
                      subtitle: Text('Email'),
                      title: Text(
                        '$email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 76, 158, 132),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                logout(context);
                DatabaseHelper().clearCurrentUser();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 110, vertical: 10),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
