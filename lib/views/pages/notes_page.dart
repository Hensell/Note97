import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_97/api/models/note_model.dart';
import 'package:note_97/views/pages/settings_page.dart';
import 'package:note_97/views/pages/write_note_page.dart';
import 'package:provider/provider.dart';

import '../../api/provider/sembast_provider.dart';
import '../../api/provider/theme_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TickerProviderStateMixin {
  late SembastProvider db;
  final myController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 220);
  late AnimationController _animationController;

  @override
  void initState() {
    db = SembastProvider();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  double screenHeight(BuildContext context) {
    return (window.physicalSize.height / window.devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        centerTitle: true,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Metal Notes", style: TextStyle(fontSize: 28)),
                RotationTransition(
                  turns: CurvedAnimation(
                      parent: _animationController, curve: Curves.linear),
                  child: IconButton(
                    onPressed: () {
                      _animationController.forward(from: 0.0);
                      //   FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 150), () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                const SettingsPage()));
                      });
                    },
                    icon: const Icon(Icons.settings_rounded),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: myController,
                    onChanged: (value) async {
                      _debouncer.run(() {
                        setState(() {});
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Buscar",
                    ),
                  ),
                ),
                AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: myController.text.isNotEmpty ? 78 : 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              myController.clear();
                            });
                          },
                          child: const Text('Cancelar')),
                    )),
              ],
            ),
          ],
        ),
      ),
      body: Container(
          color: AppColors.backgroud,
          child: FutureBuilder(
            future:
                Provider.of<SembastProvider>(context, listen: true).getNotes(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ));
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      if (snapshot.data[index].title
                          .toLowerCase()
                          .contains(myController.text.toLowerCase())) {
                        return dismissibleMethod(snapshot, index, context);
                      } else {
                        return Container();
                      }
                    });
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading task list'));
              } else {
                return const Center(child: Text('No tasks found'));
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  FocusScope.of(context).unfocus();
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

Route _createRoute(Widget destination) {
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
}

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
      //padding: _isPressed ? EdgeInsets.all(15) : EdgeInsets.all(20),
      duration: const Duration(milliseconds: 150),
      margin: !_isPressed
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),

      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(5),
        color: AppColors.customContainer,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.notemodel.title!,
              style: TextStyle(fontSize: 30, color: AppColors.fontColor),
            ),
            subtitle: Text(
              "${widget.notemodel.date} | ${widget.notemodel.content!.length > 100 ? widget.notemodel.content!.substring(0, 100) : widget.notemodel.content!}",
              style: TextStyle(fontSize: 16, color: AppColors.fontColor),
            ),
            trailing: Icon(
              Icons.edit,
              color: AppColors.iconColor,
            ),
            onTap: () async {
              setState(() {
                _isPressed = true;
              });
              await Future.delayed(const Duration(milliseconds: 140), () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => WriteNotePage(
                            isNew: false,
                            noteModel: widget.notemodel,
                          )),
                );
              });

              setState(() {
                _isPressed = false;
              });
            },
          ),
        ],
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
