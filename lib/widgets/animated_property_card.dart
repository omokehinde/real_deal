import 'package:flutter/material.dart';
import 'package:real_deal/models/offer.dart';
import 'package:real_deal/utils/app_colors.dart';
import 'package:real_deal/utils/constants.dart';
import 'package:real_deal/widgets/property_address_pill.dart';

class AnimatedPropertyCard extends StatelessWidget {
  final Offer offer;
  final bool isFeatured;
  final AnimationController controller;
  final double delay; // Add required delay parameter

  const AnimatedPropertyCard({
    super.key,
    required this.offer,
    required this.controller,
    required this.delay, // Make delay required
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isFeatured ? 200 : 150,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/property.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (!isFeatured) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.subtext,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${offer.distance} km from center',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.subtext,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        // Animated address pill with delayed animation
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Interval(
                delay,
                delay + 0.2, // Animation duration of 0.2
                curve: Curves.easeOut,
              ),
            )),
            child: PropertyAddressPill(
              address: offer.address,
              onNavigate: () {
                debugPrint('Navigate to details for ${offer.address}');
              },
            ),
          ),
        ),
      ],
    );
  }
}