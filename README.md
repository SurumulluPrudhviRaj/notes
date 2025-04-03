# notes

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


https://www.youtube.com/watch?v=0RWLaJxW7Oc&t=2488s


Here's the detailed explanation of the **code flow** step by step to help you understand how the code works from start to finish:

### 1. **App Initialization and Setup**:
- When the app starts, the `HomePage` widget is created. This is because the `HomePage` widget is set as the home screen in the `MaterialApp` (the root widget).
  
```dart
runApp(MyApp()); // Starts the app and renders HomePage.
```

### 2. **HomePage Widget**:
- The `HomePage` widget is a **StatefulWidget**, meaning it has mutable state that can change over time. This widget has a state class called `_HomePageState`.

### 3. **Creating the Stateful Widget's State**:
- In the `createState` method of `HomePage`, the `_HomePageState` class is created. This class holds the state and UI logic for the `HomePage` widget.
  
```dart
State<HomePage> createState() => _HomePageState();
```

- Inside `_HomePageState`, the following important objects are initialized:
  - `firestoreService`: An instance of the `FirestoreService` class. This service is responsible for interacting with Firebase Firestore (adding, updating, retrieving, and deleting notes).
  - `textController`: A `TextEditingController` for managing the text input field where notes are entered.

### 4. **Building the UI**:
- The `build` method is called to render the UI of `HomePage`. The method defines the entire layout, including:
  - **AppBar**: The app bar displays the title "Notes".
  - **FloatingActionButton**: A button with a plus icon (`Icons.add`) that, when clicked, opens the dialog for adding a new note.
  - **StreamBuilder**: A widget that listens for real-time updates from Firestore and updates the UI whenever the data changes.

```dart
body: StreamBuilder<QuerySnapshot>(
  stream: firestoreService.getNotesStream(),
  builder: (context, snapshot) { ... }
)
```

### 5. **StreamBuilder**:
- **StreamBuilder** listens to a stream of data provided by `firestoreService.getNotesStream()`. This stream emits `QuerySnapshot` data that contains all the notes stored in Firestore.
  - The `builder` function inside the `StreamBuilder` is responsible for rendering the UI based on the state of the stream (loading, error, or data).
  - While waiting for data, a **loading spinner** (`CircularProgressIndicator`) is shown.
  - If an error occurs while fetching data, an error message is displayed.
  - Once the data is successfully fetched, the notes are displayed in a **`ListView.builder`**.

### 6. **Rendering Notes in ListView**:
- **ListView.builder** renders the list of notes as `ListTile` widgets. Each `ListTile` has:
  - The note text displayed as the title.
  - **Trailing icons** for editing and deleting the note.
  
```dart
ListTile(
  title: Text(noteText),
  trailing: Row(
    children: [
      IconButton(onPressed: () => openNoteBox(docID: docId), icon: Icon(Icons.settings)), // Edit icon
      IconButton(onPressed: () => deleteNote(), icon: Icon(Icons.delete)), // Delete icon
    ],
  ),
)
```

### 7. **Adding a New Note**:
- When the **FloatingActionButton** (with the plus icon) is clicked, the method `openNoteBox()` is called without a `docID`, which means we are adding a **new note**.
  
  - The `openNoteBox()` method:
    1. Clears the `textController` (to reset the input field).
    2. Shows a dialog with a text field to enter a note.
    3. Once the user enters the note and presses the **Save** button, the note is either:
      - **Added** to Firestore by calling `firestoreService.addNote(note)` if no `docID` is passed.
    4. After saving, a **SnackBar** message ("Note saved!") is shown, and the dialog is closed.

### 8. **Editing an Existing Note**:
- When the **Edit icon** (`Icons.settings`) is clicked in any `ListTile`, the `openNoteBox()` method is called with the `docID` of the selected note.
  
  - The `openNoteBox(docID)` method:
    1. Fetches the current note content from Firestore by calling `firestoreService.getNoteById(docID)`.
    2. Updates the `textController` with the existing note text.
    3. Opens the same dialog as for adding a note, but this time, the text field is pre-filled with the existing note's content.
    4. When the user presses the **Save** button, the note is **updated** in Firestore by calling `firestoreService.updateNotes(docID, note)`.

### 9. **Deleting a Note**:
- When the **Delete icon** (`Icons.delete`) is clicked, the `deleteNote(docID)` method is called for the selected note.

  - The `deleteNote(docID)` method:
    1. Calls `firestoreService.deleteNote(docID)` to delete the note from Firestore.
    2. Once the note is deleted, a **SnackBar** message ("Note deleted!") is shown, confirming the deletion.
    3. If an error occurs during deletion, an error message is shown in a **SnackBar**.

### 10. **FirestoreService Class**:
The `FirestoreService` class contains methods to:
  - **Add a note** (`addNote`).
  - **Update a note** (`updateNotes`).
  - **Get a note by ID** (`getNoteById`).
  - **Stream all notes** (`getNotesStream`).
  - **Delete a note** (`deleteNote`).

Each of these methods interacts with Firebase Firestore using the Firestore SDK's methods, such as `add()`, `update()`, `get()`, `snapshots()`, and `delete()`.

### Code Flow Summary:

1. **App Starts** → `HomePage` widget is created and rendered.
2. **StreamBuilder** listens to real-time updates from Firestore.
3. **FloatingActionButton** pressed → `openNoteBox()` is called → Opens dialog for adding a new note.
4. **Save Button in Dialog** → Saves the note to Firestore (if adding a new note) or updates the existing note (if editing).
5. **Edit Icon in ListTile** → `openNoteBox(docID)` is called → Loads existing note and opens dialog for editing.
6. **Delete Icon in ListTile** → Deletes the note from Firestore.
7. **Real-time updates** are shown in the UI thanks to the `StreamBuilder`.

### Key Points:
- **Real-time Updates**: Firestore's `snapshots()` method allows the UI to automatically update whenever data changes in the Firestore database.
- **Dialogs**: Used for adding and editing notes, providing a simple way to interact with the user.
- **State Management**: `setState` is used to update the UI whenever the content changes (e.g., when loading a note for editing).
- **SnackBars**: Provide feedback to the user after saving, deleting, or encountering errors.

This flow allows for a seamless and responsive user experience where users can add, update, view, and delete notes, and see the changes immediately.

