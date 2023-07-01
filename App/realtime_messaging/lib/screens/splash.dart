import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Services/contact_services.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'welcome.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    savedUsers=[];
    savedNumber=[];
    ContactServices().getContactPermission(context);

    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
             builder: (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  debugPrint('${snapshot.hasData}');
                  return (snapshot.hasData)? HomePage():const WelcomePage();
                })

      ));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Feel Connected',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Caveat',
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            ClipOval(
              clipper: CustomCircularClipper(80),
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/chatrix_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Text(
              'Chatrix',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'IBM Plex Serif',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCircularClipper extends CustomClipper<Rect> {
  final double radius;

  CustomCircularClipper(this.radius);

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
