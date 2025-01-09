import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon; // Menambahkan parameter ikon

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon, // Menambahkan parameter ikon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24), // Ukuran ikon
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
    );
  }
}
