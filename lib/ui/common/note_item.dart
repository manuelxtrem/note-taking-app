import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';

class NoteListItem extends StatefulWidget {
  final Note note;
  final Function? onDeleted;
  final Function? onSelected;

  const NoteListItem({super.key, required this.note, this.onSelected, this.onDeleted});

  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  bool _deleteMode = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(45, 20, 30, 20)),
        backgroundColor:
            MaterialStateProperty.all(_deleteMode ? AppColors.red : AppColors.babyPowderBlue),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      onPressed: () {
        if (_deleteMode) {
          cancelTimer();
          // TODO start after dialog closes
          return;
        }
      },
      onLongPress: () {
        HapticFeedback.lightImpact();
        setState(() {
          _deleteMode = true;
        });
        startTimer();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _deleteMode ? 0 : 1,
            child: Text(
              widget.note.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.body1.copyWith(color: AppColors.black),
            ),
          ),
          if (_deleteMode) AppIcon.delete.draw(size: 30),
        ],
      ),
    );
  }

  startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _deleteMode = false;
      });
    });
  }

  cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
