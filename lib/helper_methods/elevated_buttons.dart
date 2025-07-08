import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String pieceName;
  const MyElevatedButton({
    super.key,
    required this.onPressed,
    required this.pieceName,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(pieceName),
    );
  }
}
