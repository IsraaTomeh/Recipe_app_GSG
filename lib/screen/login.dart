import 'package:flutter/material.dart';
import 'package:food_recipe/provider/FavoriteProvider.dart';
import 'package:food_recipe/Db/dataBaseHelper.dart';
import 'package:food_recipe/widgtes/custom_text_field.dart';
import 'package:food_recipe/widgtes/routes.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final dbHelper = DatabaseHelper();
  _login() async {
    final db = DatabaseHelper();
    final user = await db.getUser(emailCont.text, passwordCont.text);

    if (user != null) {
      await db.saveCurrentUser(
        user['firstName'],
        user['lastName'],
        user['email'],
      );
      final user2 = await db.getCurrentUser();
      if (user2 != null) {
        var email = user2['email'];
        print('Loaded user: $email');
      } else {
        print('User not found');
      }
      final favoriteProvider = FavoriteProvider();
      await favoriteProvider.loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 254, 254),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon.png', width: 380, height: 380),

                const SizedBox(height: 20),

                CustomTextField(
                  hint: 'Enter your email',
                  isPassword: false,
                  cont: emailCont,
                  validator: (email) {
                    if (email!.contains('@') && email.contains('.')) {
                      return null;
                    }
                    return 'Enter a valid email';
                  },
                ),

                const SizedBox(height: 25),

                CustomTextField(
                  hint: 'Enter your password',
                  isPassword: true,
                  cont: passwordCont,
                  validator: (password) {
                    if (password!.length >= 8) {
                      return null;
                    }
                    return 'Weak password';
                  },
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.signup);
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 76, 158, 132),
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 158, 132),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var user = await dbHelper.getUser(
                        emailCont.text,
                        passwordCont.text,
                      );
                      if (user != null) {
                        int userId = user['id'];
                        await _login();
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.app,
                          arguments: userId,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email or password incorrect '),
                          ),
                        );
                      }
                    }
                  },

                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 10,
                    ),
                    child: Text(
                      'Login',
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
        ),
      ),
    );
  }
}
