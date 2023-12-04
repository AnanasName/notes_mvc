import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Note.dart';

class NoteEditPage extends StatefulWidget {
  final Note? note;

  NoteEditPage({this.note});

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descriptionController.text = widget.note!.description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveNote() {
    Note note = Note(
      title: titleController.text,
      description: descriptionController.text,
    );
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать заметку'),
        actions: [
          IconButton(
            onPressed: saveNote,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Текст',
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
