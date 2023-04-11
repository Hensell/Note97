import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/provider/text_provider.dart';
import '../pages/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarBody extends StatefulWidget {
  const AppBarBody({super.key, required this.animationController});
  final AnimationController animationController;

  @override
  State<AppBarBody> createState() => _AppBarBodyState();
}

class _AppBarBodyState extends State<AppBarBody> {
  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      toolbarHeight: 180,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Note 97",
                  style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.onPrimary)),
              RotationTransition(
                turns: CurvedAnimation(
                    parent: widget.animationController, curve: Curves.linear),
                child: IconButton(
                  onPressed: () {
                    widget.animationController.forward(from: 0.0);

                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const SettingsPage()));
                    });
                  },
                  icon: Icon(
                    Icons.settings_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer),
                  /*  controller: Provider.of<TextProvider>(context, listen: false)
                      .textEditingController,*/
                  controller: myController,
                  onChanged: (value) async {
                    Provider.of<TextProvider>(context, listen: false)
                        .updateText(value);
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.search,
                  ),
                ),
              ),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: Provider.of<TextProvider>(context, listen: true)
                          .textEditingController
                          .text
                          .isNotEmpty
                      ? 78
                      : 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: TextButton(
                        onPressed: () {
                          Provider.of<TextProvider>(context, listen: false)
                              .clearText();
                          myController.clear();
                          setState(() {});
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        )),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
