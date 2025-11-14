import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    required this.cont,
    required this.validator,
  });
  final String hint;
  final bool isPassword;
  final TextEditingController cont;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        obscureText: isPassword,
        controller: cont,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(252, 235, 234, 234),
        ),
        validator: validator,
      ),
    );
  }
}
