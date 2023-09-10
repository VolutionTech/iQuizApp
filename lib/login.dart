import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';

import 'Animation/FadeAnimation.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'PK';
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  String phoneNo = "";
  bool isValidPhone = false;
  var isErrorVisible = false.obs;
  var isOPTScreen = false.obs;
  String _verificationId = "";
  String _smsCode = "";

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    controller.text = "3004737434";
    phoneNo = "+92" + controller.text;
    isValidPhone = true;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 350,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(1, Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3, Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.5, Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text("Welcome", style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8, Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Form(
                          key: formKey,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                    duration: Duration(seconds: 1),
                                    child: isOPTScreen.value
                                        ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              IconButton(onPressed: () {
                                                isOPTScreen.value = false;
                                              }, icon: Icon(Icons.arrow_back)),
                                              Text("Back"),
                                              Spacer(),
                                              Text("00:00")
                                            ],),
                                            Pinput(
                                            length: 6,
                                              onCompleted: (pin) {
                                                isErrorVisible.value = false;
                                                _smsCode = pin;
                                              },
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top:12.0),
                                              child: Row(children: const [
                                                Spacer(),
                                                Icon(Icons.restart_alt),
                                                Text("Resend"),
                                                Spacer(),
                                              ],),
                                            )

                                          ],
                                        )
                                        :
                                    InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        phoneNo = number.phoneNumber ?? "";
                                        isErrorVisible.value = false;
                                      },
                                      onInputValidated: (bool value) {
                                        isValidPhone = value;
                                      },
                                      selectorConfig: const SelectorConfig(
                                        selectorType: PhoneInputSelectorType
                                            .BOTTOM_SHEET,
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode
                                          .disabled,
                                      selectorTextStyle: const TextStyle(
                                          color: Colors.black),
                                      initialValue: number,
                                      textFieldController: controller,
                                      formatInput: true,
                                      keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: false, decimal: true),
                                      inputBorder: const OutlineInputBorder(),
                                      onSaved: (PhoneNumber number) {
                                        if (kDebugMode) {
                                          print('On Saved: $number');
                                        }
                                      },
                                    ),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(-1.0, 0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),

                                  AnimatedContainer(
                                    duration: const Duration(seconds: 4),
                                    child: Visibility(
                                      visible: isErrorVisible.value,
                                      child:  Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "Please enter a valid ${isOPTScreen.value ? "OTP" : "phone number"}.",
                                          style: const TextStyle(
                                            fontSize: 10,
                                              color: Colors.red
                                          ),),
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }),
                          ),
                        ),
                      )),
                      const SizedBox(height: 30,),
                      GestureDetector(
                        onTap: () async {
                          if (isOPTScreen.value) {
                            FirebaseAuth _auth = FirebaseAuth.instance;
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                verificationId: _verificationId,
                                smsCode: _smsCode);
                            try {
                              UserCredential firebaseUser =
                              await _auth.signInWithCredential(credential);

                              Fluttertoast.showToast(
                                  msg: _auth.currentUser?.phoneNumber ?? "",
                                  backgroundColor: Colors.black26,
                                  textColor: Colors.white);
                            } catch(e) {
                              isErrorVisible.value = true;
                            }
                          } else {
                            if (isValidPhone) {
                              try {
                                _verifyPhoneNumber(phoneNo);
                              } catch(error) {
                                isErrorVisible.value = true;
                              }
                            } else {
                              isErrorVisible.value = true;
                            }
                          }
                        },
                        child: FadeAnimation(2,

                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ]
                                  )
                              ),
                              child: const Center(
                                child: Text("Continue",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            )),
                      ),
                      const SizedBox(height: 70,),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Error: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        isOPTScreen.value = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');


    this.number = number;
  }

}