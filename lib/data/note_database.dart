import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_taking_app/data/config_database.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/res/constants.dart';

class NotesDatabase {
  late Box<Note> _box;
  bool _hasData = false;

  NotesDatabase() {
    _initialize();
  }

  void _initialize() {
    _box = Hive.box<Note>(Constants.notesBox);
  }

  Iterable<Note> getNotes() {
    final list = _box.values;
    _hasData = _box.values.isNotEmpty;
    return list;
  }

  bool hasData() {
    return _hasData;
  }

  Future saveNote(Note note) async {
    await _box.put(note.id, note);
  }

  Future addNote(Note note) async {
    await _box.put(note.id, note);
  }

  Future deleteNote(Note note) async {
    await _box.delete(note.id);
  }

  Future<Iterable<Note>> getUnsyncedNotes({required ConfigDatabase configDatabase}) async {
    DateTime lastSync = configDatabase.getLastSyncDate();

    return getNotes().where((item) => !item.isSynced(lastSync));
  }
}
