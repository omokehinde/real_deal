import 'package:flutter/material.dart';
import 'package:real_deal/screens/search_screen.dart';
import 'package:real_deal/utils/app_colors.dart';



class AnimatedActionButtons extends StatelessWidget {
  final AnimationController controller;

  AnimatedActionButtons({super.key, required this.controller});

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: controller,
    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
  );

  late final Animation<int> _buyNumberAnimation = IntTween(
    begin: 200,
    end: 1034,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
  ));

  late final Animation<int> _rentNumberAnimation = IntTween(
    begin: 200,
    end: 2212,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
  ));

  void _navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            children: [
              _buildCircularButton(
                context,
                topLabel: 'BUY',
                value: _buyNumberAnimation.value.toString(),
                bottomLabel: 'offers',
              ),
              const SizedBox(width: 16),
              _buildRectangularButton(
                context,
                topLabel: 'RENT',
                value: _rentNumberAnimation.value.toString(),
                bottomLabel: 'offers',
              ),
            ],
          ),
        );
      },
    );
  }

   Widget _buildCircularButton(
    BuildContext context, {
    required String topLabel,
    required String value,
    required String bottomLabel,
  }) {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: () => _navigateToSearch(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bottomLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRectangularButton(
    BuildContext context, {
    required String topLabel,
    required String value,
    required String bottomLabel,
  }) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _navigateToSearch(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topLabel,
                style: const TextStyle(
                  color: AppColors.subtext,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.subtext,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bottomLabel,
                style: const TextStyle(
                  color: AppColors.subtext,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}