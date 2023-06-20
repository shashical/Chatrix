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
  TextEditingController phoneNoController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        child: Stack(
          children:
          [
            ClipPath(
            clipper:BottomWaveClipper(),
              child: Container(
                color: const Color.fromARGB(255, 210, 131, 225),
                width: double.infinity,
                height: 420,
              ),
            ),
            ClipPath(
              clipper:BottomWaveClipper(),
              child: Container(
                color: const Color.fromARGB(255, 187, 12, 215),
                width: double.infinity,
                height: 400,
              ),
            ),
            Positioned(
              top: 180,
                left: 20,
                child: BlurryContainer(
                  color: Colors.white.withOpacity(0.4),
                  blur: 2,
                  elevation: 6,
                  height: 500,
                  width: 350,
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.white
                      ),
                      ),
                      SizedBox(height: 50,),
                      Text("Enter your number ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                            color: Colors.white
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: phoneNoController,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Text(' +91',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                          border: OutlineInputBorder(


                                borderRadius: BorderRadius.circular(10),


                          )
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(

                        onPressed: ()async{
                          String phoneNo=phoneNoController.text;
                          try{
                            final credential = await FirebaseAuth.instance.verifyPhoneNumber(
                                verificationCompleted: (_){},
                                verificationFailed:(e){
                                  showDialog(context: (context),
                                      builder:(context){
                                        return AlertDialog(

                                          content: Text('${e.message}'),
                                          actions: [
                                            Builder(
                                                builder: (context) {
                                                  return ElevatedButton(
                                                      onPressed: (){
                                                        Navigator.of(context,rootNavigator: true).pop();
                                                      },
                                                      child: const Text('OK'));
                                                }
                                            )
                                          ],
                                        );});
                                },
                                codeSent: ( String verificationId,int? token ){
                                  Navigator.push((context),
                                      MaterialPageRoute(builder: (context)=>VerifyOtpPage(phoneNo: phoneNo, verificationId: verificationId, token: token!,))).then((value){
                                    phoneNoController.clear;

                                  });
                                },
                                codeAutoRetrievalTimeout: (e){
                                  showDialog(context: (context),
                                      builder:(context){
                                        return AlertDialog(

                                          content: Text('${e}'),
                                          actions: [
                                            Builder(
                                                builder: (context) {
                                                  return ElevatedButton(
                                                      onPressed: (){
                                                        Navigator.of(context,rootNavigator: true).pop();
                                                      },
                                                      child: const Text('OK'));
                                                }
                                            )
                                          ],
                                        );});
                                }
                            );


                          }on FirebaseException catch(e){
                            showDialog(context: (context),
                                builder:(context){
                                  return AlertDialog(

                                    content: Text('${e.message}'),
                                    actions: [
                                      Builder(
                                          builder: (context) {
                                            return ElevatedButton(
                                                onPressed: (){
                                                  Navigator.of(context,rootNavigator: true).pop();
                                                },
                                                child: const Text('OK'));
                                          }
                                      )
                                    ],
                                  );});


                          }
                          catch(e){
                            showDialog(context: (context), builder:(context) {
                              return AlertDialog(

                                content: Text('${e}'),
                                actions: [
                                  Builder(
                                      builder: (context) {
                                        return ElevatedButton(
                                            onPressed: (){
                                              Navigator.of(context,rootNavigator: true).pop();
                                            },
                                            child: const Text('OK'));
                                      }
                                  )
                                ],
                              );
                            });
                          }

                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Login',
                            style: TextStyle(
                                fontSize: 25
                            ),),
                        ),
                      ),




                    ],
                  ),
                )
            )

          ]
        ),
      ),
    );
  }
}
