import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'QuizScreen.dart';
import 'constants.dart';
import 'onboarding/onboarding.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showConfirmationDialog(context); // Show the dialog
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collectionUser)
            .where(dbKeyPhone, isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // You can show a loading indicator here
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Error: ${snapshot.error}');
          } else {
            // Check if any documents were returned
            if (snapshot.data!.docs.isNotEmpty) {
              Map<String, dynamic> data =
              snapshot.data!.docs[0].data() as Map<String, dynamic>;
              return QuizView();
            } else {
              print(snapshot.data!.docs);
              return OnBoarding(phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "",);
            }
          }
        },
      ),



    ); // Replace with actual implementation
  }


  void _logout() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    print('User logged out');
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
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                _logout(); // Log out the user
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

