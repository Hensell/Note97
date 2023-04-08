import 'package:flutter/material.dart';
import 'package:note_97/api/provider/appbar_provider.dart';
import 'package:note_97/api/provider/sembast_provider.dart';
import 'package:note_97/api/provider/text_provider.dart';
import 'package:note_97/api/provider/theme_provider.dart';
import 'package:note_97/views/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<SembastProvider>(
      create: (_) => SembastProvider(),
    ),
    ChangeNotifierProvider<ThemesProvider>(
      create: (_) => ThemesProvider(),
    ),
    ChangeNotifierProvider<AppBarProvider>(
      create: (_) => AppBarProvider(),
    ),
    ChangeNotifierProvider<TextProvider>(
      create: (_) => TextProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Full Metal Note',
      theme: Provider.of<ThemesProvider>(context).selectedTheme,
      home: const NotesPage(),
    );
  }
}
