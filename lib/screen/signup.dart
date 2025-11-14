import 'package:flutter/material.dart';
import 'package:food_recipe/Db/dataBaseHelper.dart';
import 'package:food_recipe/widgtes/custom_text_field.dart';
import 'package:food_recipe/widgtes/routes.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  TextEditingController cont = TextEditingController();
  TextEditingController nameCont2 = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmedCont = TextEditingController();
  TextEditingController nameCont1 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 254, 254),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon.png', width: 270, height: 270),
                SizedBox(height: 30),
                CustomTextField(
                  hint: 'Enter your first name',
                  isPassword: false,
                  cont: nameCont1,
                  validator: (name) {
                    return name!.length >= 3 ? null : 'Enter A Valid Name';
                  },
                ),
                SizedBox(height: 25),
                CustomTextField(
                  hint: 'Enter your Last name',
                  isPassword: false,
                  cont: nameCont2,
                  validator: (name) {
                    return name!.length >= 3 ? null : 'Enter A Valid Name';
                  },
                ),
                SizedBox(height: 25),
                CustomTextField(
                  hint: 'Enter your email',
                  isPassword: false,
                  cont: cont,
                  validator: (email) {
                    if (email!.contains('@') && email.contains('.')) {
                      return null;
                    }
                    return 'Enter a Valid Email';
                  },
                ),
                SizedBox(height: 25),
                CustomTextField(
                  hint: 'Enter your password',
                  isPassword: true,
                  cont: passwordCont,
                  validator: (password) {
                    if (password!.length >= 8) {
                      return null;
                    }
                    return 'Week password';
                  },
                ),
                SizedBox(height: 25),
                CustomTextField(
                  hint: 'confirm password',
                  isPassword: true,
                  cont: confirmedCont,
                  validator: (confirmPassword) {
                    return (confirmPassword == passwordCont.text &&
                            confirmPassword!.isNotEmpty)
                        ? null
                        : 'Password must match';
                  },
                ),
                SizedBox(height: 25),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  },
                  child: Text(
                    "Alredy have an account? Login",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 76, 158, 132),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 158, 132),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String firstName = nameCont1.text;
                      String lastName = nameCont2.text;
                      String email = cont.text;
                      String password = passwordCont.text;

                      bool exists = await dbHelper.checkEmailExists(email);
                      if (exists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email already exists '),
                          ),
                        );
                        return;
                      }

                      await dbHelper.insertUser(
                        firstName,
                        lastName,
                        email,
                        password,
                      );
                      await dbHelper.saveCurrentUser(
                        firstName,
                        lastName,
                        email,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account created successfully'),
                        ),
                      );

                      Navigator.pushReplacementNamed(context, Routes.app);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 10,
                    ),
                    child: Text(
                      'Sign up',
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
