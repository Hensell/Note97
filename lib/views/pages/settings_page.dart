import 'package:flutter/material.dart';
import 'package:full_metal_note/api/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ajustes"),
      ),
      body: Column(
        children: [containerCustom(1), containerCustom(0), containerCustom(2)],
      ),
    );
  }

  Container containerCustom(int theme) {
    return Container(
      color: const Color(0xffFFB4A3),
      width: double.infinity,
      height: 100,
      child: MaterialButton(
        onPressed: () {
          Provider.of<ThemesProvider>(context, listen: false)
              .setSelectedTheme(theme);
        },
        child: const Text("Change"),
      ),
    );
  }
}
