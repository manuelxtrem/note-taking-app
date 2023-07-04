import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/ui/common/dialogs.dart';

class NoteListItem extends StatefulWidget {
  final Note note;
  final Color? color;
  final Function? onDeleted;
  final Function? onSelected;

  const NoteListItem({super.key, required this.note, this.onSelected, this.onDeleted, this.color});

  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  bool _deleteMode = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(45, 20, 30, 20)),
        backgroundColor: MaterialStateProperty.all(
            _deleteMode ? AppColors.red : widget.color ?? AppColors.babyPowderBlue),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      onPressed: () async {
        if (_deleteMode) {
          _cancelTimer();
          await _deleteNote();
          _startTimer();
          return;
        }

        _selectNote();
      },
      onLongPress: () {
        HapticFeedback.lightImpact();
        setState(() {
          _deleteMode = true;
        });
        _startTimer();
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
              textAlign: TextAlign.start,
              style: AppStyle.body1.copyWith(color: AppColors.black),
            ),
          ),
          if (_deleteMode) AppIcon.delete.draw(size: 30),
        ],
      ),
    );
  }

  _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _deleteMode = false;
      });
    });
  }

  _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future _deleteNote() async {
    final opt = await Dialogs.showDoubleOptionDialog(
      context,
      'Are your sure you want delete this note ?',
      positiveLabel: 'Keep',
      negativeLabel: 'Delete',
    );
    if (opt == DialogAction.negative) {
      widget.onDeleted?.call();
    }

    // remove delete button
    setState(() {
      _deleteMode = false;
    });
  }

  void _selectNote() {
    widget.onSelected?.call();
  }
}
