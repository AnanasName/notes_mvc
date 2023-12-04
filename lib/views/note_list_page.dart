import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/notes_controller.dart';
import '../models/Note.dart';
import 'note_edit_page.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends StateMVC<NoteListPage> {
  late NotesController _con;

  _NoteListPageState() : super(NotesController()) {
    _con = controller as NotesController;
  }

  @override
  void initState() {
    super.initState();
    _con.loadNotes();
  }

  void addNote() async {
    Note? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage()),
    );
    if (result != null) {
      setState(() {
        _con.addNote(result);
      });
    }
  }

  void editNote(int index) async {
    Note? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditPage(note: _con.notes[index]),
      ),
    );
    if (result != null) {
      setState(() {
        _con.editNote(result, index);
      });
    }
  }

  void deleteNote(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить заметку?'),
          content: const Text('Вы действительно хотите удалить эту заметку?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
    if (confirm != null && confirm) {
      setState(() {
        _con.deleteNote(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: _con.notes.length,
        itemBuilder: (context, index) {
          String title = _con.notes[index].title;
          String description = _con.notes[index].description;
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text(description),
              onTap: () => editNote(index),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteNote(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
