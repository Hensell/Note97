import 'package:flutter/material.dart';
import 'package:note_97/api/provider/theme_provider.dart';
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
        children: [
          containerCustom(1, 'Dark'),
          containerCustom(0, 'Light'),
          containerCustom(2, 'Green')
        ],
      ),
    );
  }

  Container containerCustom(int theme, String name) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      color: AppColors.customContainer,
      width: double.infinity,
      height: 100,
      child: MaterialButton(
        onPressed: () {
          Provider.of<ThemesProvider>(context, listen: false)
              .setSelectedTheme(theme);
          setState(() {});
        },
        child: Text(name),
      ),
    );
  }
}
