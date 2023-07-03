import 'package:flutter/material.dart';
import 'package:note_taking_app/res/styles.dart';

class EmptyList extends StatelessWidget {
  final Widget? image;
  final String text;

  const EmptyList({super.key, this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) image! else Image.asset('assets/image/rafiki.png'),
            const SizedBox(height: 6),
            Text(text, style: AppStyle.body3),
          ],
        ),
      ),
    );
  }
}
