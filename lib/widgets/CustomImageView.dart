import 'package:flutter/material.dart';

class CustomImageView extends StatelessWidget {
  final String assetPath; // Use asset path directly
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;
  final Color? borderColor;

  const CustomImageView({
    super.key,
    required this.assetPath, // Accept asset path directly
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 50.0, // Default border radius for circular images
    this.borderColor = const Color.fromARGB(255, 159, 159, 159),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // Wrap the widget in a Center widget to ensure it is centered
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width ?? 100.0, // Default width for the image
          height: height ?? 100.0, // Default height for the image
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? Colors.blue[100]!, // Light blue border
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 224, 224, 224)
                    .withOpacity(0.3), // Lighter gray shadow
                spreadRadius: 3, // Shadow spread radius
                blurRadius: 2, // Shadow blur radius
                offset: const Offset(0, 3), // Shadow offset (x, y)
              ),
            ],
          ),
          child: Image.asset(
            assetPath, // Directly load the asset
            fit: fit!,
          ),
        ),
      ),
    );
  }
}
