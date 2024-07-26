import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
  
            

          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15), // Match border radius with MyTextField
          boxShadow: [
            BoxShadow(
              color: Colors.black45, // Slightly darker shadow for a more cohesive look
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.2, // Slightly adjusted letter spacing
            ),
          ),
        ),
      ),
    );
  }
}
