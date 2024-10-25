import 'package:flutter/material.dart';
import 'package:real_deal/utils/app_colors.dart';


class AnimatedLocationHeader extends StatelessWidget {
  final AnimationController controller;

  AnimatedLocationHeader({super.key, required this.controller});

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: controller,
    // curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    curve: const Interval(0.0, 1, curve: Curves.easeOut),
  );

  late final Animation<Offset> _slideAnimation = Tween<Offset>(
    begin: const Offset(0, 0.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
  ));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.location_on_outlined, 
                          color: Colors.black54, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Saint Petersburg',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.secondary,
                  backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
                ),

              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Hi, Marina',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.subtext,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'let\'s select your perfect place',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}