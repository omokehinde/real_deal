// import 'package:flutter/material.dart';
// import 'package:real_deal/utils/constants.dart';
// import 'package:real_deal/widgets/home/action_buttons.dart';
// import 'package:real_deal/widgets/home/location_header.dart';
// import 'package:real_deal/widgets/property_listing_section.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView( 
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.pink.shade50,
//                     Colors.pink.shade100,
//                   ],
//                 ),
//               ),
//               child: const SafeArea(
//                 bottom: false,
//                 child: Padding(
//                   padding: EdgeInsets.all(Constants.defaultPadding),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       LocationHeader(),
//                       SizedBox(height: 24),
//                       ActionButtons(),
//                       SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding( 
//               padding: const EdgeInsets.all(Constants.defaultPadding),
//               child: PropertyListingSection(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:real_deal/utils/constants.dart';
import 'package:real_deal/widgets/animated_property_listing_section.dart';
import 'package:real_deal/widgets/home/animated_action_buttons.dart';
import 'package:real_deal/widgets/home/animated_location_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedLocationHeader(controller: _controller),
                      const SizedBox(height: 24),
                      AnimatedActionButtons(controller: _controller),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: AnimatedPropertyListingSection(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}