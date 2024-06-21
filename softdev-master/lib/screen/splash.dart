import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/userAuth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('images/Logo.jpg'),
      title: Text(
        'LET HIM COOK',
        style: TextStyle(
          color: Colors.pink,
          fontFamily: 'ro',
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: background,
      showLoader: true,
      loaderColor: Colors.pink,
      navigator: LoginPage(),
      durationInSeconds: 3,
    );
  }
}
