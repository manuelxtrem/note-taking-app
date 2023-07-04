import 'package:flutter/widgets.dart';

enum EditorMode { add, edit, view }

class EditorConfig {
  final EditorMode mode;
  final Color? color;

  EditorConfig({required this.mode, this.color});

  EditorConfig copyWith({EditorMode? mode, Color? color}) {
    return EditorConfig(mode: mode ?? this.mode, color: color ?? this.color);
  }
}
