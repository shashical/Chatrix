import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Widgets/BottomWaveClipper.dart';
class VerifyOtpPage extends StatefulWidget {
  final String phoneNo;
  final String verificationId;
  final int token;

   VerifyOtpPage({Key? key , required this.phoneNo, required this.verificationId, required this.token}) : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
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
                        Text('VERIFY OTP ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 50,),
                        Text('An OTP has been send to +91${widget.phoneNo[0]}*****${widget.phoneNo.substring(6)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                          fontSize: 25
                        ),),
                        Text("Enter OTP ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 40,
                              child: TextField(
                                onChanged: (value){
                                  if(value.length==1){
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style:Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8)
                                  )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 40,
                              child: TextField(
                                onChanged: (value){
                                  if(value.length==1){
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style:Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 40,
                              child: TextField(
                                onChanged: (value){
                                  if(value.length==1){
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style:Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 40,
                              child: TextField(
                                onChanged: (value){
                                  if(value.length==1){
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style:Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 40,
                              child: TextField(
                                onChanged: (value){
                                  if(value.length==1){
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style:Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 40,
                              child: TextField(
                                onChanged: (value){
                                  if(value.length==1){
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style:Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                          
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(onPressed: (){},
                            child: SizedBox(
                              width: 200,
                                
                                child: Text('Verify')))
                        




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
