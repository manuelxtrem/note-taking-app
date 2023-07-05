import 'package:flutter/material.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/styles.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final style = AppStyle.body5.copyWith(color: AppColors.textMuted);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Designed by - Divya Kelaskar', style: style),
        Text('Redesigned by - Emmanuel O. Agadzi', style: style),
        Text('Illustrations - StorySet', style: style),
        Text('Icons - Divya Kelaskar', style: style),
        Text('Font - Nunito (Google fonts)', style: style),
        Text('Image - Unsplash', style: style),
      ],
    );
  }
}
