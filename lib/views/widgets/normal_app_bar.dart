import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_97/views/widgets/app_bar_body.dart';

class NormalAppBar extends StatefulWidget {
  const NormalAppBar({super.key});

  @override
  State<NormalAppBar> createState() => _NormalAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(180);
}

class _NormalAppBarState extends State<NormalAppBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: AppBarBody(animationController: _animationController));
  }
}
