import 'package:cicada_flutter/src/screens/welcome_screen.dart';
import 'package:cicada_flutter/src/theme/cicada_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CicadaApp extends StatelessWidget {
  const CicadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Cicada — Vaccine Forecast',
        theme: CicadaTheme.light,
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      ),
    );
  }
}
