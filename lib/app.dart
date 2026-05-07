import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/routes.dart';
import 'features/login/cubit/login_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: MaterialApp.router(
        title: 'Event Check-in',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.lexendTextTheme()),
        routerConfig: createRouter(),
      ),
    );
  }
}
