import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/screens/loginPage.dart';

class NoteRepo {
  User? currentUser = FirebaseAuth.instance.currentUser;
  // ignore: non_constant_identifier_names
  Signupuser(String userName, String userPhone, String userEmail,
      String userPassword, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .set({
        'username': userName,
        "userphone": userPhone,
        'useremail': userEmail,
        'createdAt': DateTime.now(),
        'userid': currentUser!.uid, //this is the current logged in users id
      }).then((value) async {
        await FirebaseAuth.instance.signOut();
        print("UserDataSaved");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      });
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void showSnackbar(BuildContext context, String? msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
