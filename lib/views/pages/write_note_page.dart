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
  final FocusNode myFocusNode = FocusNode();
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
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
          return true;
        } else if (_titleController.text != widget.noteModel?.title ||
            _contentController.text != widget.noteModel!.content) {
          var shouldPop = await showAlertDialog(context);

          return shouldPop ?? false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  if ((_titleController.text.isNotEmpty ||
                      _contentController.text.isNotEmpty)) {
                    (widget.isNew)
                        ? Provider.of<SembastProvider>(context, listen: false)
                            .addNote(saveData())
                        : Provider.of<SembastProvider>(context, listen: false)
                            .updateNotes(updateData());

                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
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
                margin: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(myFocusNode);
                  },
                  cursorColor: Theme.of(context).colorScheme.onTertiary,
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
                  focusNode: myFocusNode,
                  cursorColor: Theme.of(context).colorScheme.onTertiary,
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
      ),
    );
  }

  Future<dynamic> showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.exitDialog,
            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                // Return false to prevent the view from being disposed
                Navigator.pop(context, false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onTertiary),
              child: Text(
                AppLocalizations.of(context)!.ok,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              onPressed: () {
                // Return true to allow the view to be disposed
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
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
