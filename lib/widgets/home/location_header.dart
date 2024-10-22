import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              backgroundColor: AppColors.secondary.withOpacity(0.1),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 20,
              ),
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
    );
  }
}