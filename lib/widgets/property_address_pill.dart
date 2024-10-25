import 'package:flutter/material.dart';
import 'package:real_deal/utils/app_colors.dart';

class PropertyAddressPill extends StatelessWidget {
  final String address;
  final VoidCallback? onNavigate;

  const PropertyAddressPill({
    super.key,
    required this.address,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 20, right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5), // Set background to semi-transparent white
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              address,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.subtext,
                size: 24,
              ),
              onPressed: onNavigate,
            ),
          ),
        ],
      ),
    );
  }
}
