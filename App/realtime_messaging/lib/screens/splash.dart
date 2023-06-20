import 'package:flutter/material.dart';
import 'welcome.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1,milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
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
            Text(
              'Feel Connected',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Caveat',
                //fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            ClipOval(
              clipper: CustomCircularClipper(80),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/chatrix_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
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
