import 'dart:async';
import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_97/api/models/note_model.dart';
import 'package:note_97/api/provider/player_provider.dart';
import 'package:note_97/views/pages/write_note_page.dart';
import 'package:provider/provider.dart';

import '../../api/provider/appbar_provider.dart';
import '../../api/provider/sembast_provider.dart';

import '../../api/provider/text_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TickerProviderStateMixin {
  late SembastProvider db;
  // final myController = TextEditingController();
  // final _debouncer = Debouncer(milliseconds: 220);
  late AnimationController _animationController;

  late Animation<double> animation;
  late AnimationController controller;
  final playerProvider = PlayerProvider();
  @override
  void initState() {
    db = SembastProvider();
    if (kIsWeb) {
      db.init();
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: -1.0, end: 1.0).animate(controller);

    controller.repeat();

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          _isLoading = false;
        }));
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  double screenHeight(BuildContext context) {
    return (window.physicalSize.height / window.devicePixelRatio);
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: SizedBox(
                // color: Theme.of(context).colorScheme.primary,
                height: 300,
                width: 300,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                )),
          )
        : Scaffold(
            appBar: Provider.of<AppBarProvider>(context, listen: true).selected,
            body: FutureBuilder(
              future: Provider.of<SembastProvider>(context, listen: true)
                  .getNotes(Provider.of<TextProvider>(context, listen: true)
                      .textEditingController
                      .text),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ));
                } else if (snapshot.hasData) {
                  return AnimatedGrid(
                    key: UniqueKey(),
                    initialItemCount: snapshot.data.length,
                    itemBuilder: (_, index, Animation<double> animation) {
                      return dismissibleMethod(snapshot, index, context);
                    },
                    //shrinkWrap: true,
                    primary: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 800 ? 4 : 2,
                      childAspectRatio: MediaQuery.of(context).size.width > 800
                          ? 9 / 10
                          : 0.59,
                      // maxCrossAxisExtent: 3, // or whatever aspect ratio you need
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading task list'));
                } else {
                  return const Center(child: Text('No tasks found'));
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                unFocus(context);

                /*   final player = AudioPlayer();
                await player.setSource(AssetSource('sounds/8bit/8bit.mp3'));
                player.play(player.source!);*/
                Provider.of<PlayerProvider>(context, listen: false).playSound();
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => const WriteNotePage(
                          isNew: true,
                        )));
              },
              tooltip: AppLocalizations.of(context)!.addNote,
              child: const Icon(Icons.add),
            ),
          );
  }

  unFocus(BuildContext context) {
    if (!FocusScope.of(context).hasPrimaryFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  Dismissible dismissibleMethod(
      AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
    return Dismissible(
      key: Key(snapshot.data[index].id.toString()),
      onDismissed: (direction) {
        bool delete = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.deletedSuccessfully),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
                label: AppLocalizations.of(context)!.undo,
                onPressed: () {
                  delete = true;
                  setState(() {});
                }),
          ),
        );
        Future.delayed(const Duration(seconds: 3), () {
          if (!delete) {
            Provider.of<SembastProvider>(context, listen: false)
                .deleteNote((snapshot.data[index]));
          }
        });
        /*  Timer.periodic(const Duration(seconds: 3), (timer) async {
          if (!delete) {
            Provider.of<SembastProvider>(context, listen: false)
                .deleteNote((snapshot.data[index]));
          }
        });*/
      },
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: const Interval(
              0.0,
              0.5,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: MyContainer(notemodel: snapshot.data[index]),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Route createRoute(Widget destination) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

/*Route _createRoute(Widget destination) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.decelerate;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}*/

class MyContainer extends StatefulWidget {
  const MyContainer({
    super.key,
    required this.notemodel,
  });

  final NoteModel notemodel;

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: () {
        setState(() {
          _isPressed = false;
        });
      },
      duration: const Duration(milliseconds: 150),
      margin: !_isPressed
          ? const EdgeInsets.symmetric(horizontal: 5, vertical: 5)
          : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Card(
          child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () async {
          setState(() {
            _isPressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 160), () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => WriteNotePage(
                        isNew: false,
                        noteModel: widget.notemodel,
                      )),
            );
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              //   softWrap: false,
              " ${widget.notemodel.title!}",
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.secondary),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onTertiary,
              thickness: 3,
            ),
            Text(
              "${widget.notemodel.date}",
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).colorScheme.secondary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 11,
                softWrap: false,
                widget.notemodel.content!,
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      )
          /* ListTile(
          title: Text(
            " ${widget.notemodel.title!.length > 10 ? widget.notemodel.title!.substring(0, 10) : widget.notemodel.title!}",
            style: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.secondary),
          ),
          subtitle: Text(
            "${widget.notemodel.date} | ${widget.notemodel.content!.length > 180 ? widget.notemodel.content!.substring(0, 180) : widget.notemodel.content!}",
            style: TextStyle(
                fontSize: 14, color: Theme.of(context).colorScheme.secondary),
          ),
          onTap: () async {
            setState(() {
              _isPressed = true;
            });
            await Future.delayed(const Duration(milliseconds: 160), () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => WriteNotePage(
                          isNew: false,
                          noteModel: widget.notemodel,
                        )),
              );
            });
          },
        ),*/
          ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
