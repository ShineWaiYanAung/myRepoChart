import 'package:flutter/material.dart';

class CustomInnerConcaveContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: ConcaveLeftClipper(),
          child: Container(
            height: 200,
            width: 200,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class ConcaveLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 40.0; // Radius for the concave curve

    Path path = Path();
    // Top-left concave curve
    path.moveTo(radius, 0);
    path.quadraticBezierTo(0, size.height * 0.1, 0, radius);

    // Left side
    path.lineTo(0, size.height - radius);

    // Bottom-left concave curve
    path.quadraticBezierTo(
        0, size.height - (size.height * 0.1), radius, size.height);

    // Bottom, right, and top sides
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(radius, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
