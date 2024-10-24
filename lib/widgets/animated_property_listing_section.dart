import 'package:flutter/material.dart';
import 'package:real_deal/models/offer.dart';
import 'package:real_deal/utils/constants.dart';
import 'package:real_deal/widgets/animated_property_card.dart';

class AnimatedPropertyListingSection extends StatelessWidget {
  final AnimationController controller;

  AnimatedPropertyListingSection({
    super.key,
    required this.controller,
  });

  final List<Offer> offers = List.generate(
    7,
    (index) => Offer(
      id: 'offer-$index',
      address: index == 0 ? 'Gladkova St, 20' : 'Gladkova St, 4${index + 2}',
      price: 250000 + (index * 50000),
      imageUrl: Constants.placeholderImage,
      distance: 2.5 + (index * 0.5),
      isForRent: index % 2 == 0,
      latitude: Constants.defaultLatitude,
      longitude: Constants.defaultLongitude,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Featured Property with slide-up animation
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
          )),
          child: AnimatedPropertyCard(
            offer: offers[0],
            isFeatured: true,
            controller: controller,
            delay: 0.3, // Add delay for featured property
          ),
        ),
        const SizedBox(height: 16),
        // Rest of the properties in rows of two
        for (int i = 1; i < offers.length; i += 2) ...[
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Interval(
                0.3 + (i * 0.1),
                0.5 + (i * 0.1),
                curve: Curves.easeOut,
              ),
            )),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedPropertyCard(
                    offer: offers[i],
                    controller: controller,
                    delay: 0.4 + (i * 0.1), // Add delay for each card
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: i + 1 < offers.length
                      ? AnimatedPropertyCard(
                          offer: offers[i + 1],
                          controller: controller,
                          delay: 0.4 + (i * 0.1), // Add delay for each card
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}