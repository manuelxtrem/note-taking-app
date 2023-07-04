import 'package:flutter/material.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/ui/common/button.dart';

enum DialogAction { negative, positive }

class Dialogs {
  static Future<DialogAction?> showWidgetDialog(BuildContext context, Widget child,
      {bool dismissable = true}) async {
    return showDialog(
      context: context,
      barrierColor: AppColors.background2.withOpacity(.3),
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          content: child,
          contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 38),
          alignment: Alignment.center,
        );
      },
    );
  }

  static Future<DialogAction?> showSingleOptionDialog(BuildContext context, String message,
      {bool dismissable = true, String? buttonLabel}) async {
    return showDialog(
      context: context,
      barrierColor: AppColors.background2.withOpacity(.3),
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          icon: AppIcon.infoFilled.draw(size: 30),
          content: Text(message,
              style: AppStyle.body2.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            AppTextButton(
              text: (buttonLabel ?? 'OK'),
              color: AppColors.grey,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(DialogAction.negative);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<DialogAction?> showDoubleOptionDialog(BuildContext context, String message,
      {bool dismissable = true, String? positiveLabel, String? negativeLabel}) async {
    return showDialog(
      context: context,
      barrierColor: AppColors.background2.withOpacity(.3),
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          icon: AppIcon.infoFilled.draw(size: 30),
          content: Text(
            message,
            style: AppStyle.body2.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
          actionsOverflowDirection: VerticalDirection.down,
          actions: [
            AppTextButton(
              text: (negativeLabel ?? 'No'),
              color: AppColors.red,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(DialogAction.negative);
              },
            ),
            const SizedBox(width: 35),
            AppTextButton(
              text: (positiveLabel ?? 'Yes'),
              color: AppColors.green,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(DialogAction.positive);
              },
            ),
          ],
        );
      },
    );
  }
}
