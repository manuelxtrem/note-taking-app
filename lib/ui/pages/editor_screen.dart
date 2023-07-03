// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/ui/common/button.dart';
import 'package:note_taking_app/ui/common/dialogs.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: AppIconButton(
          icon: AppIcon.chevron,
          size: 19,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (_editMode)
            AppIconButton(
              icon: AppIcon.eye,
              onPressed: () {},
            ),
          const SizedBox(width: 20),
          if (_editMode)
            AppIconButton(
              icon: AppIcon.save,
              onPressed: () => _onSaveNote(),
            )
          else
            AppIconButton(
              icon: AppIcon.pencil,
              onPressed: () => _onEditNote(),
            ),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: AppStyle.headline2.copyWith(color: AppColors.textMuted),
                border: InputBorder.none,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: AppStyle.headline2,
              enabled: _editMode,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type something...',
                hintStyle: AppStyle.body2.copyWith(color: AppColors.textMuted),
                border: InputBorder.none,
              ),
              style: AppStyle.body2,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              enabled: _editMode,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveNote() async {
    final opt1 = await Dialogs.showDoubleOptionDialog(
      context,
      'Save changes ?',
      positiveLabel: 'Save',
      negativeLabel: 'Discard',
    );
    if (opt1 == DialogAction.negative) {
      final opt2 = await Dialogs.showDoubleOptionDialog(
        context,
        'Are your sure you want discard your changes ?',
        positiveLabel: 'Keep',
        negativeLabel: 'Discard',
      );
      if (opt2 == DialogAction.positive) {
        // TODO
      }
    }
  }

  void _onEditNote() {
    setState(() {
      _editMode = true;
    });
  }
}
