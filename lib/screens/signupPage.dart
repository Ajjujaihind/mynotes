import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mynotes/screens/loginPage.dart';
import 'package:mynotes/services/NoteRepo.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool obscurePassword = true;

  void showSnackbar(BuildContext context, String? msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

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
                    Icon(Icons.menu_sharp),
                    Text("Signup Page"),
                    Icon(Icons.more_vert)
                  ],
                ),
              ),

              ///custom app bar

              ///login icons
              Container(
                height: 240,
                child: LottieBuilder.asset("assets/images/signup.json"),
              ),
              SizedBox(
                height: 10,
              ),

              ///login icons

              ///usernamefield
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Username'),
                ),
              ),

              ///usernamefield

              ///Phonefield
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: phonecontroller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Phone'),
                ),
              ),

              ///Phonefield

              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Email'),
                ),
              ),

              ///emailfield
              SizedBox(
                height: 10,
              ),

              ///passwordfield
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_rounded),
                      suffixIcon: InkWell(
                        onTap: () {
                          obscurePassword == true
                              ? obscurePassword = false
                              : obscurePassword = true;
                          setState(() {});
                        },
                        child: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Password'),
                ),
              ),

              ///passwordfield
              SizedBox(
                height: 10,
              ),

              ///LoginButton
              ElevatedButton(
                  onPressed: () async {
                    var userName = usernamecontroller.text.trim().toString();
                    var userPhone = phonecontroller.text.trim().toString();
                    var userEmail = emailcontroller.text.trim().toString();
                    var userPassword =
                        passwordcontroller.text.trim().toString();
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: userEmail,
                        password: userPassword,
                      )
                          .then((value) {
                        print("User created");
                        NoteRepo().Signupuser(userName, userPhone, userEmail,
                            userPassword, context);
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        // ignore: use_build_context_synchronously
                        showSnackbar(context, e.code.toString());
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        // ignore: use_build_context_synchronously
                        showSnackbar(context, e.code.toString());
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      showSnackbar(context, e.toString());
                      print(e);
                    }
                  },
                  child: Text(
                    "Signup",
                    style: TextStyle(color: Colors.black),
                  )),

              /// ///LoginButton

              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                child: Text(
                  "Already  have an account Login",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        )),
      )),
    );
  }
}
