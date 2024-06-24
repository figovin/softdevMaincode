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
  void initState() {
    super.initState();
    // Navigate to the login page after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/Logo.png',
              width: 250, // Adjust the width as needed
              height: 250, // Adjust the height as needed
              fit: BoxFit.contain, // Ensure the image fits within the specified dimensions
            ),
            SizedBox(height: 20),
            Text(
              'Please Wait',
              style: TextStyle(
                color: Colors.pink,
                fontFamily: 'ro',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
          ],
        ),
      ),
    );
  }
}