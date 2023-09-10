import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import '../Animation/FadeAnimation.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();

  String? _photoUrl;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalkey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: <Widget>[
          imageProfile(),
          SizedBox(height: 20),
          nameTextField(),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (_globalkey.currentState!.validate()) {
                // Save name to user collection
                await saveNameToUserCollection(_name.text);

                // If a photo is selected, upload it and link it to the user collection
                if (_photoUrl != null) {
                  String downloadUrl = await uploadPhoto();
                  await linkPhotoToUserCollection(downloadUrl);
                }
              }
            },
            child: FadeAnimation(
              2,
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      !_name.text.isEmpty
                          ? Color.fromRGBO(143, 148, 251, .6)
                          : Color.fromRGBO(143, 148, 251, 1),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
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
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
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
              child: Icon(
                Icons.edit,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveNameToUserCollection(String name) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(userId).set({
      'name': name,
    });
  }

  Future<String> uploadPhoto() async {
    String userId = _auth.currentUser!.uid;
    Reference ref = _storage.ref().child('user_photos/$userId.jpg');

    // Get the local file path of the selected image
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localFilePath = '${appDocDir.path}/selected_image.jpg';

    UploadTask uploadTask = ref.putFile(File(localFilePath));
    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> linkPhotoToUserCollection(String photoUrl) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(userId).update({
      'photoUrl': photoUrl,
    });
  }
}
