import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final double width;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.blue,
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: padding,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
