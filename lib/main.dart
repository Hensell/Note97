import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_metal_note/api/provider/sembast_provider.dart';
import 'package:full_metal_note/api/provider/theme_provider.dart';
import 'package:full_metal_note/views/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<SembastProvider>(
      create: (_) => SembastProvider(),
    ),
    ChangeNotifierProvider<ThemesProvider>(
      create: (_) => ThemesProvider(),
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
