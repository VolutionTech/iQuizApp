import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController _nameController = TextEditingController();
  String? _photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Open a photo picker to select an image
                // You can implement this using an image picker library
                // and set the _photoUrl variable with the selected image URL.
              },
              child: Text('Select Photo'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final String name = _nameController.text.trim();
                if (name.isNotEmpty && name.length >= 3 && name.length <= 20) {
                  if (_photoUrl == null) {
                    // Validate the name and photo, then save to Firebase
                    final User? user = _auth.currentUser;
                    if (user != null) {
                      await _firestore.collection('users').doc(user.uid).set({
                        'name': name,
                        'photoUrl': _photoUrl,
                      });
                      // Navigate to the next screen or perform any desired action
                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
                    }
                  } else {
                    // Handle photo not selected
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Photo Not Selected'),
                          content: Text('Please select a photo before saving.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Handle invalid name
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid Name'),
                        content: Text('Name must be between 3 and 20 characters.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                height: 50.0,
                alignment: Alignment.center,
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
