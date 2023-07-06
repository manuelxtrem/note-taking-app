import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:note_taking_app/data/config_database.dart';
import 'package:note_taking_app/data/note_database.dart';
import 'package:note_taking_app/data/note_repository.dart';
import 'package:note_taking_app/model/note.dart';

class MockNotesDatabase extends Mock implements NotesDatabase {
  @override
  Iterable<Note> getNotes() {
    return super
        .noSuchMethod(Invocation.method(#getNotes, []), returnValue: const Iterable<Note>.empty());
  }

  @override
  Future saveNote(Note? note) async {
    return super.noSuchMethod(Invocation.method(#saveNote, [note]));
  }

  @override
  Future addNote(Note? note) async {
    return super.noSuchMethod(Invocation.method(#addNote, [note]));
  }

  @override
  Future deleteNote(Note? note) async {
    return super.noSuchMethod(Invocation.method(#deleteNote, [note]));
  }

  @override
  bool hasData() {
    return super.noSuchMethod(Invocation.method(#hasData, []), returnValue: false);
  }

  @override
  Future<Iterable<Note>> getUnsyncedNotes({ConfigDatabase? configDatabase}) async {
    return super.noSuchMethod(Invocation.method(#getUnsyncedNotes, [configDatabase]),
        returnValue: const Iterable<Note>.empty());
  }
}

class MockConfigDatabase extends Mock implements ConfigDatabase {
  MockConfigDatabase();
  
  @override
  DateTime getLastSyncDate() {
    return super.noSuchMethod(Invocation.method(#getLastSyncDate, [DateTime.now()]));
  }

  @override
  Future setLastSyncDate(DateTime dateTime) async {}

  @override
  String? getUserId() {
    return super.noSuchMethod(Invocation.method(#getUserId, ['fake_uid']));
  }

  @override
  Future setUserId(String user) async {}
}

class MockNotesRepository extends Mock implements NotesRepository {
  @override
  Future<void> syncNotes({
    NotesDatabase? notesDatabase,
    ConfigDatabase? configDatabase,
    Connectivity? connectivity,
    bool? freshInstall,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#syncNotes, [notesDatabase, configDatabase, connectivity, freshInstall]),
    );
  }

  @override
  Future<void> syncOfflineNotes(
      {NotesDatabase? notesDatabase, ConfigDatabase? configDatabase}) async {
    return super.noSuchMethod(
      Invocation.method(#syncOfflineNotes, [notesDatabase, configDatabase]),
    );
  }

  @override
  Future<void> syncOnlineNotes({NotesDatabase? notesDatabase, bool? freshInstall}) async {
    return super.noSuchMethod(
      Invocation.method(#syncOfflineNotes, [notesDatabase, freshInstall]),
    );
  }
}

class MockConnectivity extends Mock implements Connectivity {
  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return super.noSuchMethod(Invocation.method(#checkConnectivity, []),
        returnValue: ConnectivityResult.mobile);
  }
}

class MockGoogleAuthProvider extends Mock implements GoogleAuthProvider {

}