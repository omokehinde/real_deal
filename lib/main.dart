// import 'package:flutter/material.dart';
// import 'screens/home_screen.dart';

// void main() {
//   runApp(const RealDealApp());
// }

// class RealDealApp extends StatelessWidget {
//   const RealDealApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Real Deal',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const RealDealApp());
}

class RealDealApp extends StatelessWidget {
  const RealDealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Deal',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainNavigation(),
    );
  }
}