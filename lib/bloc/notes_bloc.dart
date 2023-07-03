import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_taking_app/model/note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final String _boxName = 'notes_box';
  late Box _box;
  final List<Note> _allNotes = [];
  List<Note> get allNotes => _allNotes;

  NotesBloc() : super(NotesInitialState()) {
    on<NotesEvent>((event, emit) async {
      if (event is InitNotesEvent) {
        await _init(emit);
      } else if (event is GetAllNotesEvent) {
        await _getAllnotes(emit);
      }
    });
  }

  Future _init(Emitter<NotesState> emit) async {
    _box = await Hive.openBox<List<Note>>(_boxName);
    emit(NotesIdleState());
  }

  Future _getAllnotes(Emitter<NotesState> emit) async {
    _allNotes.clear();
    _allNotes.addAll(_box.get('list', defaultValue: const []));

    emit(NotesListState(_allNotes));
  }
}
