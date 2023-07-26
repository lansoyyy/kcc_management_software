import 'package:flutter/material.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? fontSize;
  final double? height;
  final double? radius;
  final Color? color;
  final Color? fontColor;

  const ButtonWidget(
      {super.key,
      required this.label,
      required this.onPressed,
      this.width = 300,
      this.fontSize = 18,
      this.height = 50,
      this.radius = 5,
      this.color = Colors.blue,
      this.fontColor = Colors.black});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!)),
        minWidth: width,
        height: height,
        color: color,
        onPressed: onPressed,
        child: TextBold(text: label, fontSize: fontSize!, color: fontColor!));
  }
}
