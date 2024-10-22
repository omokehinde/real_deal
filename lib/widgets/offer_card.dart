import 'package:flutter/material.dart';
import '../models/offer.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.cardBorderRadius),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.address,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: AppColors.subtext),
                    const SizedBox(width: 4),
                    Text(
                      '${offer.distance} km from center',
                      style: const TextStyle(color: AppColors.subtext),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}