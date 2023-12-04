import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/Note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesController extends ControllerMVC {
  factory NotesController() {
    _this ??= NotesController._();
    return _this!;
  }

  static NotesController? _this;

  NotesController._();

  List<Note> notes = [];
  TextEditingController todoTitleController = TextEditingController();

  Future saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedNotes = notes.map((note) {
      return '${note.title},${note.description}';
    }).toList();
    await prefs.setStringList('notes', savedNotes);
  }

  Future loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = (prefs.getStringList('notes') ?? []).map((note) {
        List<String> noteData = note.split(',');
        return Note(
          title: noteData[0],
          description: noteData[1],
        );
      }).toList();
    });
  }

  void addNote(Note note){
    notes.add(note);
    saveNotes();
  }

  void editNote(Note note, int index){
    notes[index] = note;
    saveNotes();
  }

  void deleteNote(int index){
    notes.removeAt(index);
    saveNotes();
  }
}
