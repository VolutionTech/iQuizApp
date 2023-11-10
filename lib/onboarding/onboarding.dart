
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get.dart';
import '../constants.dart';

class OnBoarding extends StatefulWidget {
  final String phone;
  const OnBoarding({Key? key, required this.phone}) : super(key: key);

  @override
  _OnBoardingState createState() {
    return _OnBoardingState();
  }
}

class _OnBoardingState extends State<OnBoarding> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  var isLoading = false.obs;
  String? _photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: appbarColor, actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            _showConfirmationDialog(context);
          },
        ),
      ],),

      body: Form(
      key: _globalkey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: <Widget>[
          imageProfile(),
          SizedBox(height: 20),
          nameTextField(),
          SizedBox(height: 20),
          Obx(() => isLoading.value ? Container(child: Center(child:  CircularProgressIndicator(),),) : FlutterTextButton(
            buttonText: 'Save',
            buttonColor: Colors.black,
            textColor: Colors.white,
            buttonHeight: 50,
            buttonWidth: double.infinity,
            onTap: () async {
              if (_globalkey.currentState!.validate()) {
                // Save name to user collection
                await saveNameToUserCollection(_name.text);

              }
            },

          ),),

        ],
      ),
    ),);
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
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
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 80.0,
            backgroundImage: AssetImage(_photoUrl ?? 'assets/avatar/1.png'),
          ),

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
                                      _photoUrl =
                                      'assets/avatar/${index + 1}.png';
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

  Future<void> saveNameToUserCollection(String name) async {
    String userId = _auth.currentUser!.uid;
    isLoading.value = true;
    await _firestore.collection(collectionUser).doc(userId).set({
      'name': name,
      'photo': _photoUrl,
      dbKeyPhone: widget.phone,
    });
    isLoading.value = false;
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
                _logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    print('User logged out');
  }

}
