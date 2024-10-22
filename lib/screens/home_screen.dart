import 'package:flutter/material.dart';
import 'package:real_deal/utils/constants.dart';
import 'package:real_deal/widgets/home/action_buttons.dart';
import 'package:real_deal/widgets/home/location_header.dart';
import 'package:real_deal/widgets/property_listing_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrapping entire body
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.pink.shade50,
                    Colors.pink.shade100,
                  ],
                ),
              ),
              child: const SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.all(Constants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocationHeader(),
                      SizedBox(height: 24),
                      ActionButtons(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            Padding( // Adding padding to the listing section
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: PropertyListingSection(),
            ),
          ],
        ),
      ),
    );
  }
}

