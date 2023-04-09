import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_97/api/models/note_model.dart';
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

  @override
  void initState() {
    db = SembastProvider();
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

    setState(() {
      _isLoading = true;
    });

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

  bool _isLoading = false;

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
                  return GridView.builder(
                    key: UniqueKey(),
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return dismissibleMethod(snapshot, index, context);
                    },
                    shrinkWrap: true,
                    primary: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.59,
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
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => const WriteNotePage(
                          isNew: true,
                        )));
              },
              tooltip: 'Añadir nota',
              child: const Icon(Icons.add),
            ),
          );
  }

  Dismissible dismissibleMethod(
      AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
    return Dismissible(
      key: Key(snapshot.data[index].id.toString()),
      onDismissed: (direction) {
        Provider.of<SembastProvider>(context, listen: false)
            .deleteNote((snapshot.data[index]));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Eliminado correctamente'),
            duration: const Duration(
                seconds:
                    3), // Set the duration for which the SnackBar is visible
            behavior: SnackBarBehavior.floating, // Use the floating behavior
            margin: const EdgeInsets.only(bottom: 200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ), // Give it rounded corners
          ),
        );
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
        child: ListTile(
          title: Text(
            " ${widget.notemodel.title!.length > 10 ? widget.notemodel.title!.substring(0, 10) : widget.notemodel.title!}",
            style: TextStyle(
                fontSize: 22, color: Theme.of(context).colorScheme.secondary),
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
        ),
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
