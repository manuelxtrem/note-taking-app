import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/ui/common/empty_list.dart';
import 'package:note_taking_app/ui/common/note_list.dart';
import 'package:note_taking_app/ui/pages/home_screen.dart';

import '../mocks.dart';

void main() {
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

  final providers = [
    BlocProvider(
      create: (context) => NotesBloc(
        configDatabase: mockConfigDatabase,
        notesDatabase: mockNotesDatabase,
        notesRepository: mockNotesRepository,
        connectivity: mockConnectivity,
      ),
    ),
  ];

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

  testWidgets('HomeScreen initial state', (WidgetTester tester) async {
    when(mockNotesDatabase.getNotes()).thenReturn([]);

    await tester.pumpWidget(MultiBlocProvider(
      providers: providers,
      child: const MaterialApp(home: HomeScreen()),
    ));

    // Verify that the initial state is as expected
    expect(find.text('Notes'), findsOneWidget);
    expect(find.byType(NotesList), findsNothing);
    expect(find.byType(EmptyList), findsOneWidget);
    expect(find.text('Create your first note !'), findsOneWidget);
  });

  testWidgets('HomeScreen shows list of notes after GetAllNotesEvent called', (WidgetTester tester) async {
    when(mockNotesDatabase.getNotes()).thenReturn([sampleNote]);
    notesBloc.add(GetAllNotesEvent());

    await tester.pumpWidget(MultiBlocProvider(
      providers: providers,
      child: const MaterialApp(home: HomeScreen()),
    ));

    // Wait for all pending operations to complete
    await tester.pumpAndSettle();

    // Verify that the resulting state is as expected
    expect(find.text('Notes'), findsOneWidget);
    expect(find.byType(NotesList), findsOneWidget);
    expect(find.byType(EmptyList), findsNothing);
    expect(find.text('Create your first note !'), findsNothing);
    expect(find.text('Test Note 1'), findsOneWidget);
  });
}
