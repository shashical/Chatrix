import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realtime_messaging/Models/users.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../Widgets/BottomWaveClipper.dart';
//import 'package:encrypt/encrypt.dart' as encrypt;
//import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart' as pointy;
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNo;
  final String verificationId;
  final int token;

  const VerifyOtpPage(
      {Key? key,
      required this.phoneNo,
      required this.verificationId,
      required this.token})
      : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  TextEditingController pin1cont = TextEditingController();
  TextEditingController pin2cont = TextEditingController();
  TextEditingController pin3cont = TextEditingController();
  TextEditingController pin4cont = TextEditingController();
  TextEditingController pin5cont = TextEditingController();
  TextEditingController pin6cont = TextEditingController();
  bool isloading = false;
  CountdownController _controller = new CountdownController(autoStart: true);
  bool canresend = false;
  String? veryid = "";

  @override
  Widget build(BuildContext context) {
    setState(() {
      veryid = widget.verificationId;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          const Column(
            children: [
              Spacer(),
              Image(image: AssetImage('assets/otpverify_bgnd.png'))
            ],
          ),
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              color: const Color.fromARGB(255, 111, 0, 253),
              width: double.infinity,
              height: 777,
            ),
          ),
          ClipPath(
              clipper: BottomWaveClipper(),
              child: const Image(
                image: AssetImage('assets/otpverify_bgnd.png'),
              )),
          Positioned(
              top: 180,
              left: 20,
              child: BlurryContainer(
                color: Colors.white.withOpacity(0.4),
                blur: 2,
                elevation: 6,
                height: 500,
                width: 350,
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VERIFY OTP ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.greenAccent),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'An OTP has been send to +91${widget.phoneNo[0]}******${widget.phoneNo.substring(7)}',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text(
                      "Enter OTP ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 45,
                            child: TextFormField(
                              controller: pin1cont,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              style: Theme.of(context).textTheme.titleLarge,
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
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 45,
                            child: TextFormField(
                              controller: pin2cont,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: Theme.of(context).textTheme.titleLarge,
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
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 45,
                            child: TextField(
                              controller: pin3cont,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: Theme.of(context).textTheme.titleLarge,
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
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 45,
                            child: TextFormField(
                              controller: pin4cont,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: Theme.of(context).textTheme.titleLarge,
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
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 40,
                            child: TextFormField(
                              controller: pin5cont,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: Theme.of(context).textTheme.titleLarge,
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
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 40,
                            child: TextFormField(
                              controller: pin6cont,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: Theme.of(context).textTheme.titleLarge,
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
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              if (canresend) {
                                setState(() {
                                  canresend = false;
                                });
                                _controller.restart();
                                try {
                                  FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: "+91${widget.phoneNo}",
                                      verificationCompleted: (_) {},
                                      verificationFailed: (e) {
                                        canresend = true;
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
                                                              rootNavigator:
                                                              true)
                                                              .pop();
                                                        },
                                                        child:
                                                        const Text('OK'));
                                                  })
                                                ],
                                              );
                                            });
                                      },
                                      codeSent:
                                          (String verificationId, int? token) {
                                        veryid = verificationId;
                                        setState(() {});
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
                                  showDialog(
                                      context: (context),
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text('${e}'),
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
                              }
                            },
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: (canresend)
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            )),
                        const Text(' in ',style: TextStyle(fontSize: 26),),

                        const Spacer(),
                        Countdown(
                          controller: _controller,
                          seconds: 30,
                          build: (_, double time) => Text(
                            '00:${(time~/10).toString()}${(time%10).toString().substring(0,1)} ',
                            style: const TextStyle(
                              fontSize: 35,
                            ),
                          ),
                          interval: const Duration(milliseconds: 10),
                          onFinished: () {
                            setState(() {
                              canresend = true;
                            });
                          },
                        ),
                        
                       
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: 400,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isloading = true;
                              });
                              String p = pin1cont.text +
                                  pin2cont.text +
                                  pin3cont.text +
                                  pin4cont.text +
                                  pin5cont.text +
                                  pin6cont.text;
                              try {
                                final credential = PhoneAuthProvider.credential(
                                    verificationId: veryid!, smsCode: p);
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                                setState(() {
                                  isloading = false;
                                });

                                final id =
                                    FirebaseAuth.instance.currentUser!.uid;

                                DocumentSnapshot docSnap =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(id)
                                        .get();
                                if (!docSnap.exists) {
                                  // pointy.RSAKeyGeneratorParameters keyParams =
                                  //     pointy.RSAKeyGeneratorParameters(
                                  //         BigInt.parse('65537'), 2048, 64);
                                  // pointy.FortunaRandom secureRandom = pointy.FortunaRandom();
                                  // Random random = Random.secure();
                                  // pointy.RSAKeyGenerator keyGenerator = pointy.RSAKeyGenerator()
                                  //   ..init(pointy.ParametersWithRandom(
                                  //       keyParams, secureRandom));
                                  // pointy.AsymmetricKeyPair<pointy.PublicKey, pointy.PrivateKey> keyPair =
                                  //     keyGenerator.generateKeyPair();

                                  var keyParams =
                                      new pointy.RSAKeyGeneratorParameters(
                                          new BigInt.from(65537), 2048, 5);
                                  var secureRandom = new pointy.FortunaRandom();
                                  var random = new Random.secure();
                                  List<int> seeds = [];
                                  for (int i = 0; i < 32; i++) {
                                    seeds.add(random.nextInt(255));
                                  }
                                  secureRandom.seed(new pointy.KeyParameter(
                                      new Uint8List.fromList(seeds)));

                                  var rngParams =
                                      new pointy.ParametersWithRandom(
                                          keyParams, secureRandom);
                                  var k = new pointy.RSAKeyGenerator();
                                  k.init(rngParams);
                                  var keyPair = k.generateKeyPair();

                                  RSAPublicKey publicKey =
                                      keyPair.publicKey as RSAPublicKey;
                                  RSAPrivateKey privateKey =
                                      keyPair.privateKey as RSAPrivateKey;

                                  String publicKeyString = rsa.RsaKeyHelper()
                                      .encodePublicKeyToPemPKCS1(publicKey);
                                  String privateKeyString = rsa.RsaKeyHelper()
                                      .encodePrivateKeyToPemPKCS1(privateKey);
                                  // final mypublickey = rsa.RsaKeyHelper()
                                  //     .parsePublicKeyFromPem(publicKeyString);

                                  FlutterSecureStorage storage =
                                      const FlutterSecureStorage();

                                  await storage.write(
                                      key: id, value: privateKeyString);

                                  Users user = Users(
                                      id: id,
                                      phoneNo: "+91${widget.phoneNo}",
                                      publicKey: publicKeyString,
                                      name: '');
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.id)
                                        .set(user.toJson())
                                        .catchError(
                                            (e) => throw Exception('$e'));
                                  } on FirebaseException catch (e) {
                                    throw Exception('$e');
                                  } catch (e) {
                                    rethrow;
                                  }
                                }

                                String? fcmToken = await FirebaseMessaging.instance.getToken();

                                RemoteServices().updateUser(id, 
                                {'token': fcmToken},
                                );

                                // RemoteServices().setUsers(Users(
                                //   id: id,
                                //   name: '',
                                //   phoneNo: "+91${widget.phoneNo}",
                                //   about: '',
                                //   isOnline: true,
                                // ));

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserInfoPage()));
                              } on FirebaseAuthException catch (e) {
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
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
