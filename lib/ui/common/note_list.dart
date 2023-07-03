import 'package:flutter/material.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/ui/common/note_item.dart';

class NotesList extends StatelessWidget {
  final List<Note> items;
  const NotesList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(25, 35, 20, 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return NoteListItem(
          note: Note(title: item.title, body: item.body),
        );
      },
    );
  }
}
