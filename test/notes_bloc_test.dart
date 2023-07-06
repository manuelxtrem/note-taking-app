import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/model/note.dart';

import '_mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('NotesBloc', () {
    late NotesBloc notesBloc;
    late MockNotesDatabase mockNotesDatabase;
    late MockConfigDatabase mockConfigDatabase;
    late MockNotesRepository mockNotesRepository;
    late MockConnectivity mockConnectivity;

    final sampleNote = Note(
      id: 'fake_uuid',
      title: 'Test Note 1',
      body: 'Some interesting detail about a note that is hard to write.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setUp(() {
      mockNotesDatabase = MockNotesDatabase();
      mockConfigDatabase = MockConfigDatabase();
      mockNotesRepository = MockNotesRepository();
      mockConnectivity = MockConnectivity();

      notesBloc = NotesBloc(
        notesDatabase: mockNotesDatabase,
        configDatabase: mockConfigDatabase,
        notesRepository: mockNotesRepository,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      notesBloc.close();
    });

    test('initial state is NotesInitialState', () {
      expect(notesBloc.state, isA<NotesInitialState>());
    });

    test('emits NotesListState after GetAllNotesEvent', () async {
      final expectedState = NotesListState([sampleNote]);

      when(mockNotesDatabase.getNotes()).thenReturn([sampleNote]);
      notesBloc.add(GetAllNotesEvent());

      await expectLater(notesBloc.stream, emits(expectedState));
    });

    test('emits NotesSavedState after SaveNoteEvent', () async {
      final note = Note(
        id: 'fake_uuid',
        title: 'Test Note 1',
        body: 'Some interesting detail about a note that is hard to write.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final expectedState = NotesSavedState(note);

      notesBloc.add(SaveNoteEvent(note));

      await expectLater(notesBloc.stream, emits(expectedState));
    });

    test('emits NotesSavedState after AddNoteEvent', () async {
      final note = Note(
        id: 'fake_uuid',
        title: 'Test Note 1',
        body: 'Some interesting detail about a note that is hard to write.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final expectedState = NotesSavedState(note);

      notesBloc.add(AddNoteEvent(note));

      await expectLater(notesBloc.stream, emits(expectedState));
    });

    // Add more tests for other events and states

    test('calls syncNotes method on SyncNotesEvent', () async {
      const connectivityResult = ConnectivityResult.mobile;

      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => connectivityResult);
      when(mockNotesDatabase.getUnsyncedNotes(configDatabase: mockConfigDatabase))
          .thenAnswer((_) async => [sampleNote]);

      final expectedState = NotesSyncedState();

      notesBloc.add(SyncNotesEvent());

      await expectLater(notesBloc.stream, emits(expectedState));
    });
  });
}
