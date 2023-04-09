import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_97/api/provider/player_provider.dart';
import 'package:note_97/api/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/provider/appbar_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchValue = false;
  getSwitchValue() async {
    switchValue = await Provider.of<PlayerProvider>(context, listen: false)
        .getSoundPref();
    setState(() {});
  }

  @override
  void initState() {
    getSwitchValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ajustes"),
      ),
      body: Column(
        children: [
          containerCustom(0, 'Night', 0),
          //   containerCustom(1, 'Old news paper', 1),
          containerCustom(2, 'Kawaii', 1),
          containerCustom(3, '8-bits', 1),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sonido',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary)),
                CupertinoSwitch(
                  value: switchValue,
                  trackColor:
                      Theme.of(context).colorScheme.onTertiary.withOpacity(0.5),
                  activeColor: Theme.of(context).colorScheme.onTertiary,
                  onChanged: (bool? value) {
                    setState(() {
                      switchValue = value ?? false;
                    });
                    Provider.of<PlayerProvider>(context, listen: false)
                        .setSoundPref(switchValue);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Card containerCustom(int theme, String name, int appBarType) {
    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        width: double.infinity,
        height: 100,
        child: MaterialButton(
          onPressed: () {
            Provider.of<AppBarProvider>(context, listen: false)
                .setSelectedAppBar(appBarType);
            Provider.of<ThemesProvider>(context, listen: false)
                .setSelectedTheme(theme);
            Provider.of<PlayerProvider>(context, listen: false)
                .setSelectedSounds(theme);
          },
          child: Text(
            name,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ),
    );
  }
}
