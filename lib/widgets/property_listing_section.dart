import 'package:flutter/material.dart';
import 'package:real_deal/models/offer.dart';
import 'package:real_deal/utils/constants.dart';
import 'package:real_deal/widgets/property_card.dart';

class PropertyListingSection extends StatelessWidget {
  PropertyListingSection({super.key});

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
        // Featured Property
        PropertyCard(
          offer: offers[0],
          isFeatured: true,
        ),
        const SizedBox(height: 16),
        // Rest of the properties in rows of two
        for (int i = 1; i < offers.length; i += 2) ...[
          Row(
            children: [
              Expanded(
                child: PropertyCard(
                  offer: offers[i],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: i + 1 < offers.length
                    ? PropertyCard(
                        offer: offers[i + 1],
                      )
                    : const SizedBox(), // Empty space if odd number of properties
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
