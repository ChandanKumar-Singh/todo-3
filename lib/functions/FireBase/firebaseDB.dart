import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_3/Models/NoteModel.dart';
import 'package:todo_3/functions/function.dart';

FirebaseFirestore fireStore = FirebaseFirestore.instance;
String firDbName = 'TODO-3';
CollectionReference notesReference =
    fireStore.collection('TODO-3/users/$uid/public/notes');

class FirebaseDb {
  Future<void> addNoteToFDB(NoteModel note) async {
    print(notesReference);
    var cpath = notesReference.path.split('/');
    cpath.removeLast();
    await fireStore.doc(cpath.join('/')).set({'type': 'public'});
    await notesReference.doc(note.createdAt).set(note.toJson());
  }

  Future<void> deleteNoteFromFDB(NoteModel note) async {
    await notesReference.doc(note.createdAt).delete();
    await notesReference.doc(note.createdAt).delete();
  }
}
