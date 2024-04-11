import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Application/AppConfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Application/DataCacheManager.dart';
import '../../Application/util.dart';
import '../../Models/LoginResponseModel.dart';
import '../../Services/UserService.dart';
import '../Home/home.dart';
import 'MongoDBHandler.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final UserController userController = Get.put(UserController());

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    controller.text = "";
    return Scaffold(
      backgroundColor: Application.appbarColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return Text(
                    'Users (' + userController.users.length.toString() + ')',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }),
                SizedBox(height: 10),
                Obx(() {
                  if (userController.users.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: userController.users.map((user) {
                        return ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Choose an action:'),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            var loginResponse =
                                                await UserServices()
                                                    .loginUser(user.phone);
                                            DataCacheManager().headerToken =
                                                loginResponse?.token ?? "";
                                            updateUser(
                                                loginResponse?.user.name,
                                                loginResponse?.token,
                                                loginResponse?.user.imageName,
                                                true);
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                'phone', user.phone);
                                            Get.off(
                                                () => HomeScreen(prefs: prefs));
                                          },
                                          child: Text('View App'),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                              await launch(
                                                  "https://wa.me/${user.phone}?text=Hello");
                                            },
                                            child: Text('Open Whatsapp')),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 40.0,
                            backgroundImage: AssetImage(
                                'assets/avatar/' + user.imageName + '.png'),
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(user.phone),
                          // Add more user details as needed
                        );
                      }).toList(),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserController extends GetxController {
  var users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      // Fetch users from your database
      List<User> fetchedUsers = await MongoDbHelper.findUser();
      users.assignAll(fetchedUsers);
    } catch (error) {
      print("Error fetching users: $error");
    }
  }
}
