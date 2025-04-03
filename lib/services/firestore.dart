// Importing the necessary package for Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// This class will handle all interactions with Firestore, such as adding, updating,
// retrieving, streaming, and deleting notes.
class FirestoreService {
  // Create an instance of FirebaseFirestore to interact with the Firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new note to the 'notes' collection in Firestore
  Future<void> addNote(String note) async {
    // The 'add' method adds a new document to the 'notes' collection with a field called 'note'
    await _db.collection('notes').add({'note': note});
  }

  // Update an existing note in Firestore by its document ID (docID)
  Future<void> updateNotes(String docID, String note) async {
    // The 'doc' method selects the document by its docID, and 'update' modifies the 'note' field
    await _db.collection('notes').doc(docID).update({'note': note});
  }

  // Get an existing note from Firestore using its document ID (docID)
  Future<String> getNoteById(String docID) async {
    // Fetch the document snapshot from Firestore
    DocumentSnapshot doc = await _db.collection('notes').doc(docID).get();

    // If the document exists, return the value of the 'note' field; otherwise, return an empty string
    return doc.exists ? doc['note'] : '';
  }

  // Stream to get real-time updates of all notes in Firestore
  Stream<QuerySnapshot> getNotesStream() {
    // The 'snapshots' method returns a stream of document snapshots for the 'notes' collection
    return _db.collection('notes').snapshots();
  }

  // Delete a note from Firestore by its document ID (docID)
  Future<void> deleteNote(String docID) async {
    try {
      // The 'doc' method selects the document by its docID, and 'delete' removes it from Firestore
      await _db.collection('notes').doc(docID).delete();
    } catch (e) {
      // If an error occurs while deleting, throw an exception
      throw Exception('Failed to delete note: $e');
    }
  }
}
