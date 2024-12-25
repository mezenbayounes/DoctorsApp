import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final ShapeBorder? shape;
  final bool? isLoading;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 50.0,
    this.textStyle,
    this.padding,
    this.primaryColor,
    this.onPrimaryColor,
    this.shape,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size(width ?? double.infinity, height!)),
        padding: WidgetStateProperty.all(padding ?? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0)),
        backgroundColor: WidgetStateProperty.all(primaryColor ?? Colors.green[500]),
        foregroundColor: WidgetStateProperty.all(onPrimaryColor ?? Colors.white),
        shape: WidgetStateProperty.all((shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))) as OutlinedBorder?),
      ),
      child: isLoading!
          ? CircularProgressIndicator(color: onPrimaryColor ?? Colors.white)
          : Text(label, style: textStyle ?? medicalTextStyle()),
    );
  }

  TextStyle medicalTextStyle() {
    return const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }
}
