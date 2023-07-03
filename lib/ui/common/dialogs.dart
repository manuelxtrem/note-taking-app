import 'package:flutter/material.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/ui/common/button.dart';

enum DialogAction { negative, positive }

class Dialogs {
  static Future<T?> showWidgetDialog<T>(BuildContext context, Widget child,
      {bool dismissible = true}) async {
    return showDialog<T>(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
            child: child,
          );
        });
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
          content: Text(message, style: AppStyle.body2.copyWith(color: AppColors.textMuted)),
          actionsAlignment: MainAxisAlignment.center,
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
