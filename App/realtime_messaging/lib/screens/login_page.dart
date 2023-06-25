import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:realtime_messaging/screens/verify_otp_page.dart';
import '../Widgets/BottomWaveClipper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNoController = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          Column(
            children: [
              Spacer(),
              Image(
                image: AssetImage('assets/login_bgnd.png'),
                width: 500,
              ),
            ],
          ),
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              color: const Color.fromARGB(255, 20, 78, 225),
              width: double.infinity,
              height: 650,
            ),
          ),
          ClipPath(
              clipper: BottomWaveClipper(),
              child: Image(
                image: AssetImage('assets/login_bgnd.png'),
                width: 395,
              )),
          Positioned(
              top: 235,
              left: 20,
              child: BlurryContainer(
                color: Colors.white.withOpacity(0.4),
                blur: 2,
                elevation: 6,
                height: 400,
                width: 350,
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Enter your number ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: phoneNoController,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Text(
                            ' +91 ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 0, minHeight: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          String phoneNo = phoneNoController.text;
                          try {
                            FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: "+91" + phoneNo,
                                verificationCompleted: (_) {},
                                verificationFailed: (e) {
                                  isloading = false;
                                  setState(() {});
                                  showDialog(
                                      context: (context),
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text('${e.message}'),
                                          actions: [
                                            Builder(builder: (context) {
                                              return ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                  child: const Text('OK'));
                                            })
                                          ],
                                        );
                                      });
                                },
                                codeSent: (String verificationId, int? token) {
                                  setState(() {
                                    isloading = false;
                                  });
                                  Navigator.push(
                                      (context),
                                      MaterialPageRoute(
                                          builder: (context) => VerifyOtpPage(
                                                phoneNo: phoneNo,
                                                verificationId: verificationId,
                                                token: token!,
                                              ))).then((value) {
                                    phoneNoController.clear;
                                  });
                                },
                                codeAutoRetrievalTimeout: (_) {});
                          } on FirebaseException catch (e) {
                            setState(() {
                              isloading = false;
                            });
                            showDialog(
                                context: (context),
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('${e.message}'),
                                    actions: [
                                      Builder(builder: (context) {
                                        return ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            child: const Text('OK'));
                                      })
                                    ],
                                  );
                                });
                          } catch (e) {
                            setState(() {
                              isloading = false;
                            });
                            showDialog(
                                context: (context),
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('$e'),
                                    actions: [
                                      Builder(builder: (context) {
                                        return ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            child: const Text('OK'));
                                      })
                                    ],
                                  );
                                });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: (isloading)
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              )
                            : Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Send OTP',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
