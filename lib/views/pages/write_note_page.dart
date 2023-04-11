import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../api/models/note_model.dart';
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
                    : Provider.of<SembastProvider>(context, listen: false)
                        .updateNotes(updateData());

                Navigator.pop(context);
                /*ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added')),
                );*/
                setState(() {});
              },
              child: Text(
                widget.isNew
                    ? AppLocalizations.of(context)!.save
                    : AppLocalizations.of(context)!.modify,
                style: const TextStyle(fontWeight: FontWeight.w600),
              )),
        ],
        title: const Text("Note 97"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                controller: _titleController,
                maxLength: 100,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onTertiary), //<-- SEE HERE
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onTertiary), //<-- SEE HERE
                  ),
                  hintText: AppLocalizations.of(context)!.title,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary),
                  hintText: AppLocalizations.of(context)!.content,
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(bottom: 12.0),
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
