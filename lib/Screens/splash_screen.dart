// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Screens/tab_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
              width: 150,
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            const Image(
              image: AssetImage('assets/images/Logo1.png'),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              AppLocalizations.of(context)!.welcome,
              style: GoogleFonts.blackOpsOne(fontSize: 45),
            )
          ],
        ),
      ),
      nextScreen: const Tabs(),
      splashIconSize: 600,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
