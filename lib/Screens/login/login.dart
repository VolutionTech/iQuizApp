import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Models/LoginResponseModel.dart';
import 'package:imm_quiz_flutter/Application/url.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

import '../../Animation/FadeAnimation.dart';
import '../../Application/DataCacheManager.dart';
import '../../Application/util.dart';

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
  var isLoading = false.obs;

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    controller.text = "";
    phoneNo = "+92" + controller.text;
    isValidPhone = true;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          // physics: const NeverScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Image.asset("assets/images/appLogo.png", height: 200,),
                SizedBox(height: 30,),
                Image.asset("assets/images/textLogo.png", height: 30,),
                SizedBox(height: 100,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8,
                          Container(
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
                                              Text("")
                                            ],),
                                            Pinput(
                                            length: 6,
                                              onCompleted: (pin) {
                                                isErrorVisible.value = false;
                                                _smsCode = pin;
                                              },
                                            ),

                                            // Padding(
                                            //   padding: const EdgeInsets.only(top:12.0),
                                            //   child: Row(children: const [
                                            //     Spacer(),
                                            //     Icon(Icons.restart_alt),
                                            //     // Text("Resend"),
                                            //     Spacer(),
                                            //   ],),
                                            // )

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
                                      inputBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)
                                      ),
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
                      Obx(() => isLoading.value ? CircularProgressIndicator() : FlutterTextButton(
                        buttonText: 'Continue',
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        buttonHeight: 50,
                        buttonWidth: double.infinity,
                        onTap: () async {
                          if (isOPTScreen.value) {
                            isLoading.value = true;
                            FirebaseAuth _auth = FirebaseAuth.instance;
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                verificationId: _verificationId,
                                smsCode: _smsCode);
                            try {
                              await _auth.signInWithCredential(credential);
                              var loginResponse = await loginUser(phoneNo);
                              DataCacheManager().headerToken = loginResponse?.token ?? "";
                              updateUser(loginResponse?.user.name, loginResponse?.token, loginResponse?.user.imageName);
                              isLoading.value = false;
                              Fluttertoast.showToast(
                                  msg: _auth.currentUser?.phoneNumber ?? "",
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black);
                            } catch(e) {
                              isErrorVisible.value = true;
                              isLoading.value = false;
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

                      ),),

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
  Future<UserLoginResponse?> loginUser(String phoneNumber) async {
    final String apiUrl = baseURL+userEndPoint;
    Map<String, dynamic> requestBody = {
      "phone": phoneNumber,
      "role": "user"
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        return UserLoginResponse.fromJson(responseData);
      } else {
        // Handle other status codes/errors
        print('Login failed with status code: ${response.statusCode}');
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;

    }
  }
  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    isLoading.value = true;
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
       isLoading.value = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Error2: ${e.message}");
       isLoading.value = false;
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        isOPTScreen.value = true;
       isLoading.value = false;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
   // isLoading.value = false;
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');


    this.number = number;
  }

}