import 'package:flutter/material.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';

class AppTextButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  const AppTextButton(
      {super.key, required this.onPressed, required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 25, vertical: 5)),
        backgroundColor: MaterialStateProperty.all(color ?? AppColors.grey),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      ),
      child: Text(
        text,
        style: AppStyle.body4.copyWith(color: textColor ?? AppColors.white),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final AppIcon icon;
  final double? size;
  final Function() onPressed;

  const AppIconButton({super.key, required this.icon, required this.onPressed, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          backgroundColor: MaterialStateProperty.all(AppColors.grey),
        ),
        child: Center(child: icon.draw(size: size ?? 20)),
      ),
    );
  }
}
