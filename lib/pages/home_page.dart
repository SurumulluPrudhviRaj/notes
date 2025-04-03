// Importing the necessary packages for Firestore, Flutter Material design, and the Firestore service
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore database
import 'package:flutter/material.dart'; // Flutter Material widgets for UI
import 'package:notes/services/firestore.dart'; // Custom Firestore service to interact with Firestore

// HomePage is a StatefulWidget because it will change state when notes are added, updated, or deleted.
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor for the HomePage widget.

  @override
  State<HomePage> createState() => _HomePageState(); // Creates the state for HomePage
}

// _HomePageState is the state class for HomePage. It manages the state and UI of the HomePage widget.
class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService =
      FirestoreService(); // An instance of the FirestoreService class to interact with Firestore
  final TextEditingController textController =
      TextEditingController(); // Controller for the text input field

  // This method opens the note input dialog. It optionally takes a docID to edit an existing note.
  void openNoteBox({String? docID}) {
    // If a docID is provided, we fetch the note for that docID from Firestore
    if (docID != null) {
      firestoreService.getNoteById(docID).then((note) {
        setState(() {
          textController.text = note; // Set the note text in the text field
        });
      });
    } else {
      textController.clear(); // Clear the text field for creating a new note
    }

    // Show a dialog to input or edit the note
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller:
                  textController, // Bind the textController to the text field
              decoration: const InputDecoration(
                hintText: 'Enter note',
              ), // Display placeholder text
            ),
            actions: [
              // Save button to either add or update the note
              ElevatedButton(
                onPressed: () {
                  String note =
                      textController.text
                          .trim(); // Get the trimmed text from the text field

                  // Check if the note is empty and show a SnackBar if it is
                  if (note.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Note cannot be empty!')),
                    );
                    return;
                  }

                  // If no docID is provided, we're adding a new note, otherwise updating an existing note
                  if (docID == null) {
                    firestoreService.addNote(
                      note,
                    ); // Add the new note to Firestore
                  } else {
                    firestoreService.updateNotes(
                      docID, // Update the existing note with the given docID
                      note,
                    );
                  }

                  textController.clear(); // Clear the text field
                  Navigator.pop(context); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note saved!'),
                    ), // Show a confirmation SnackBar
                  );
                },
                child: const Text("Save"), // Button text
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ), // AppBar with the title "Notes"
      // Floating action button that opens the note input dialog to add a new note
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(), // Call openNoteBox to add a new note
        child: const Icon(Icons.add), // Icon for adding a note
      ),

      // StreamBuilder listens for real-time updates from the Firestore database
      body: StreamBuilder<QuerySnapshot>(
        stream:
            firestoreService
                .getNotesStream(), // Listen to Firestore stream of notes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, show a loading spinner
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // If there is an error, display the error message
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            // If data is available, process the notes
            List notesList =
                snapshot
                    .data!
                    .docs; // Get the list of documents (notes) from Firestore

            return ListView.builder(
              itemCount: notesList.length, // The number of notes to display
              itemBuilder: (context, index) {
                DocumentSnapshot document =
                    notesList[index]; // Get each note document
                String docId = document.id; // Get the document ID
                Map<String, dynamic> data =
                    document.data()
                        as Map<
                          String,
                          dynamic
                        >; // Get the data from the document
                String noteText =
                    data['note'] ?? 'No content available'; // Get the note text

                return ListTile(
                  title: Text(noteText), // Display the note text
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon button to edit the note
                      IconButton(
                        onPressed:
                            () => openNoteBox(
                              docID: docId,
                            ), // Pass docId to open the note for editing
                        icon: const Icon(Icons.settings),
                      ),
                      // Icon button to delete the note
                      IconButton(
                        onPressed: () {
                          // Call the deleteNote method to delete the note with the given docId
                          firestoreService
                              .deleteNote(docId)
                              .then((_) {
                                // Show a SnackBar when the note is successfully deleted
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Note deleted!'),
                                  ),
                                );
                              })
                              .catchError((error) {
                                // Show an error SnackBar if something goes wrong
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to delete note: $error',
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.delete), // Delete icon
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No notes available.'),
            ); // Display if no notes are available
          }
        },
      ),
    );
  }
}
