import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_97/views/widgets/app_bar_body.dart';

import '../../api/provider/paint_provider.dart';

class AnimatedAppBar extends StatefulWidget {
  const AnimatedAppBar({super.key});

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(180);
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animationController.forward(from: 0);
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: -1.0, end: 1.0).animate(controller);

    controller.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(180),
      child: Stack(
        children: [
          AppBarBody(animationController: _animationController),
          AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(painter: Sky());
              }),
        ],
      ),
    );
  }
}
