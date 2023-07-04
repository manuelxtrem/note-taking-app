import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/utils.dart';
import 'package:note_taking_app/ui/common/note_item.dart';
import 'package:note_taking_app/ui/pages/editor_screen.dart';

class NotesList extends StatelessWidget {
  final Iterable<Note> items;

  const NotesList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.lemonLime,
      AppColors.babyPowderBlue,
      AppColors.flamingoPink,
      AppColors.hotPink,
      AppColors.rust,
      AppColors.melon,
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(25, 35, 20, 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        final colorIndex = (index + 1) % colors.length;

        return NoteListItem(
          note: item,
          color: colors[colorIndex],
          onSelected: () {
            final notesBloc = context.read<NotesBloc>();
            notesBloc.add(SelectNoteEvent(item, mode: EditorMode.view));
            Navigator.of(context).push(Utils.pageRoute(const EditorScreen()));
          },
          onDeleted: () {
            final notesBloc = context.read<NotesBloc>();
            notesBloc.add(DeleteNoteEvent(item));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 25);
      },
    );
  }
}
