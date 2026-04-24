import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Event Check-in',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.lexendTextTheme()),
      routerConfig: createRouter(),
    );
  }
}
