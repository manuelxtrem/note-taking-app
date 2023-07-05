import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:note_taking_app/data/config_database.dart';
import 'package:note_taking_app/data/note_database.dart';
import 'package:note_taking_app/model/note.dart';

class NotesRepository {
  final CollectionReference _notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<void> _uploadNote(Note note) async {
    await _notesCollection.doc(note.id).set({
      'title': note.title,
      'body': note.body,
      'createdAt': Timestamp.fromDate(note.createdAt),
      'updatedAt': Timestamp.fromDate(note.updatedAt),
    });
  }

  Future<void> syncNotes({
    required NotesDatabase notesDatabase,
    required ConfigDatabase configDatabase,
    required Connectivity connectivity,
    bool freshInstall = false,
  }) async {
    final ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      // Retrieve unsynchronized notes from the local database
      await syncOfflineNotes(notesDatabase: notesDatabase, configDatabase: configDatabase);

      // Fetch unsynchronized notes from the remote database
      await syncOnlineNotes(notesDatabase: notesDatabase, freshInstall: freshInstall);
    }
  }

  Future<void> syncOfflineNotes(
      {required NotesDatabase notesDatabase, required ConfigDatabase configDatabase}) async {
    final Iterable<Note> unsyncedNotes =
        await notesDatabase.getUnsyncedNotes(configDatabase: configDatabase);

    bool didUpdate = false;
    for (final note in unsyncedNotes) {
      await _uploadNote(note);
      if (!didUpdate) didUpdate = true;
    }

    if (didUpdate) {
      await configDatabase.setLastSyncDate(DateTime.now());
    }
  }

  Future<void> syncOnlineNotes(
      {required NotesDatabase notesDatabase, bool freshInstall = false}) async {
    final DocumentReference settingsDoc = FirebaseFirestore.instance.doc('/config/settings');

    final DocumentSnapshot settingsRef = await settingsDoc.get();
    final Timestamp lastSync = (settingsRef.data() as Map<String, dynamic>)['lastSync'];

    final Query notesQuery = freshInstall
        ? _notesCollection
        : _notesCollection.where('updatedAt', isGreaterThan: lastSync);

    // Process unsynced notes
    final QuerySnapshot notesSnapshot = await notesQuery.get();
    bool didUpdate = false;
    for (var doc in notesSnapshot.docs) {
      final item = doc.data() as Map<String, dynamic>;
      final note = Note(
        id: doc.id,
        title: item['title'],
        body: item['body'],
        createdAt: (item['createdAt'] as Timestamp).toDate(),
        updatedAt: (item['updatedAt'] as Timestamp).toDate(),
      );

      notesDatabase.addNote(note);
      if (!didUpdate) didUpdate = true;
    }

    // Update the last sync timestamp
    if (didUpdate) {
      final now = DateTime.now();
      await settingsDoc.update({'lastSync': Timestamp.fromDate(now)});
    }
  }
}
