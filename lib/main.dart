import 'package:flutter/material.dart';
import 'package:note_97/api/provider/appbar_provider.dart';
import 'package:note_97/api/provider/player_provider.dart';
import 'package:note_97/api/provider/sembast_provider.dart';
import 'package:note_97/api/provider/text_provider.dart';
import 'package:note_97/api/provider/theme_provider.dart';
import 'package:note_97/views/pages/notes_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    ChangeNotifierProvider<PlayerProvider>(
      create: (_) => PlayerProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Note 97',
      theme: Provider.of<ThemesProvider>(context).selectedTheme,
      home: const NotesPage(),
    );
  }
}
