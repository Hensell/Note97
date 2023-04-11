import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_97/api/provider/player_provider.dart';
import 'package:note_97/api/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              containerCustom(0, 'Night', 0),
              //   containerCustom(1, 'Old news paper', 1),
              containerCustom(2, 'Kawaii', 1),
              containerCustom(3, '8-bits', 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.sound,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onTertiary)),
                    CupertinoSwitch(
                      value: switchValue,
                      trackColor: Theme.of(context)
                          .colorScheme
                          .onTertiary
                          .withOpacity(0.5),
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
        ),
      ),
    );
  }

  Card containerCustom(int theme, String name, int appBarType) {
    return Card(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Provider.of<AppBarProvider>(context, listen: false)
              .setSelectedAppBar(appBarType);
          Provider.of<ThemesProvider>(context, listen: false)
              .setSelectedTheme(theme);
          Provider.of<PlayerProvider>(context, listen: false)
              .setSelectedSounds(theme);
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 120,
          child: Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ),
    );
  }
}
