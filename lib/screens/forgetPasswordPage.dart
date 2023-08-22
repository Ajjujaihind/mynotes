import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mynotes/screens/loginPage.dart';
import 'package:mynotes/services/NoteRepo.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ///custom app bar
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back)),
                    Text("Forget Password Page"),
                    Icon(Icons.more_vert)
                  ],
                ),
              ),

              ///custom app bar

              ///login icons
              Container(
                height: 300,
                child: LottieBuilder.asset("assets/images/forget.json"),
              ),
              SizedBox(
                height: 10,
              ),

              ///login icons

              ///emailfield
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Enter Your Email...'),
                ),
              ),

              ///emailfield
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 10,
              ),

              ///LoginButton
              ElevatedButton(
                  onPressed: () async {
                    var email =
                        emailcontroller.text.trim().toString().toLowerCase();
                    if (email.isNotEmpty) {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email)
                          .then((value) {
                        print("Email Sent.....");
                      }).catchError((error) {
                        NoteRepo().showSnackbar(context, error.toString());
                        print("Failed to add user: $error");
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    } else {
                      NoteRepo()
                          .showSnackbar(context, "Plz enter valid email id");
                    }
                  },
                  child: Text(
                    "Forget Password",
                    style: TextStyle(color: Colors.black),
                  )),

              /// ///LoginButton
            ],
          ),
        )),
      )),
    );
  }
}
