import 'package:flutter/material.dart';
import 'package:real_deal/widgets/navigation/bottom_nav_bar.dart';


class AnimatedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final AnimationController controller;

  AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.controller,
  });

  late final Animation<Offset> _slideAnimation = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
  ));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}