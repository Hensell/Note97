import 'package:flutter/material.dart';
import 'package:full_metal_note/api/models/note_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../api/provider/sembast_provider.dart';

class WriteNotePage extends StatefulWidget {
  final bool isNew;
  final NoteModel? noteModel;
  const WriteNotePage({super.key, required this.isNew, this.noteModel});

  @override
  State<WriteNotePage> createState() => _WriteNotePageState();
}

class _WriteNotePageState extends State<WriteNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = (widget.isNew ? "" : widget.noteModel!.title)!;
    _contentController.text = (widget.isNew ? "" : widget.noteModel!.content)!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                (widget.isNew)
                    ? Provider.of<SembastProvider>(context, listen: false)
                        .addNote(saveData())
                    //db.addNote(saveData())
                    : Provider.of<SembastProvider>(context, listen: false)
                        .updateNotes(updateData());
                //db.updateNotes(updateData());

                Navigator.pop(context);
                /*ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added')),
                );*/
                setState(() {});
              },
              child: Text(
                widget.isNew ? "Listo" : "Modificar",
                style: const TextStyle(fontWeight: FontWeight.w600),
              )),
        ],
        title: const Text("Full Metal Notes"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: TextFormField(
                controller: _titleController,
                // initialValue: widget.isNew ? "" : widget.noteModel!.title,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: "Titulo",
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              margin:
                  const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: TextFormField(
                controller: _contentController,
                //    initialValue: widget.isNew ? "" : widget.noteModel!.content,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Contenido",
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(bottom: 12.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  saveData() {
    NoteModel noteModel = NoteModel(
        _titleController.text,
        _contentController.text,
        DateFormat('yyyy/MM/dd').format(DateTime.now()));
    return noteModel;
  }

  updateData() {
    widget.noteModel!.title = _titleController.text;
    widget.noteModel!.content = _contentController.text;
    setState(() {});
    return widget.noteModel;
  }
}
