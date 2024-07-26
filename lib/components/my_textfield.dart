import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!), // Border color when not focused
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent), // Border color when focused
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          fillColor: Colors.grey[900], // Background color
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]), // Hint text color
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside the text field
        ),
        validator: validator,
      ),
    );
  }
}
