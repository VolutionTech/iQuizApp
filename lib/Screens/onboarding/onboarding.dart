import 'package:flutter/material.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Screens/Home/home.dart';
import 'package:imm_quiz_flutter/Screens/QuizScreen/QuizAppController.dart';
import 'package:imm_quiz_flutter/Services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/AppConfiguration.dart';
import '../../Application/Constants.dart';
import '../../Application/util.dart';
import '../login/login.dart';
import 'OnBoardingController.dart';

class OnBoarding extends StatefulWidget {
  var fromHome = false;
  SharedPreferences prefs;
  OnBoarding(this.fromHome, this.prefs) {
    QuizAppController controller = Get.find();
    controller.showSearchInCate.value = false;
    controller.controller.reverse();
    controller.showSearchInQuizScreen.value = false;
    controller.controllerQ.reverse();
  }

  @override
  _OnBoardingState createState() {
    return _OnBoardingState();
  }
}

class _OnBoardingState extends State<OnBoarding> {
  final _globalkey = GlobalKey<FormState>();
  var isLoading = false.obs;
  String? _photoUrl;
  late OnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OnboardingController());
    if (widget.prefs.getBool(SharedPrefKeys.KEY_ISLOGIN) == true) {
      UserServices().getUserData((user) {
        controller.nameController.value.text = user.user.name;
        controller.imageName.value = user.user.imageName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Application.appbarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: widget.prefs.getBool(SharedPrefKeys.KEY_ISLOGIN) == true
          ? Form(
              key: _globalkey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                children: <Widget>[
                  imageProfile(),
                  SizedBox(height: 20),
                  nameTextField(),
                  SizedBox(height: 20),
                  Obx(
                    () => isLoading.value
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : FlutterTextButton(
                            buttonText: 'Save',
                            buttonColor: Application.appbarColor,
                            textColor: Colors.white,
                            buttonHeight: 50,
                            buttonWidth: double.infinity,
                            onTap: () async {
                              if (_globalkey.currentState!.validate()) {
                                isLoading.value = true;
                                var user = await UserServices().saveProfile(
                                    controller.nameController.value.text,
                                    controller.imageName.value);
                                updateUser(user?.user.name, null,
                                    user?.user.imageName, true);
                                isLoading.value = false;
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (widget.fromHome) {
                                  print("Go to home screen");
                                  Get.offAll(() => HomeScreen(prefs: prefs));
                                }
                              }
                            },
                          ),
                  ),
                  FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data!
                                .getBool(SharedPrefKeys.KEY_ISLOGIN) ==
                            true) {
                          if (!widget.fromHome) {
                            return TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteAccountDialog(
                                          onDeleteConfirmed: () {
                                        UserServices().deleteUser();
                                        logout();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  );
                                },
                                child: Text(
                                  "Delete Account",
                                  style: TextStyle(color: Colors.red),
                                ));
                          }
                        }
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            )
          : LoginView(),
    );
  }

  Widget nameTextField() {
    return Obx(() {
      return TextFormField(
        controller: controller.nameController.value,
        validator: (value) {
          if (value?.isEmpty ?? false) return "Name can't be empty";
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          labelText: "Nickname",
          hintText: "Nickname",
        ),
      );
    });
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          Obx(() {
            return CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 80.0,
              backgroundImage: AssetImage(_photoUrl ??
                  'assets/avatar/' + controller.imageName.value + '.png'),
            );
          }),
          Positioned(
            bottom: 7.0,
            right: 7.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Select Avatar",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: 21, // Number of images
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    // Handle avatar selection here
                                    // Set _photoUrl to the selected avatar URL
                                    setState(() {
                                      controller.imageName.value =
                                          "${index + 1}";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    child: Image.asset(
                                      'assets/avatar/${index + 1}.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget LoginView() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 50),
            SizedBox(
              height: 20,
            ),
            Text('Please login to view Profile.'),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: FlutterTextButton(
                buttonText: 'Login',
                buttonColor: Application.appbarColor,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                  Get.offAll(Login());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountDialog extends StatelessWidget {
  final Function onDeleteConfirmed;

  const DeleteAccountDialog({Key? key, required this.onDeleteConfirmed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Account'),
      content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDeleteConfirmed(); // Call the function to delete the account
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

// Usage example:
// Show the dialog when the delete account button is pressed
void showDeleteAccountDialog(BuildContext context, Function onDeleteConfirmed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteAccountDialog(onDeleteConfirmed: onDeleteConfirmed);
    },
  );
}
