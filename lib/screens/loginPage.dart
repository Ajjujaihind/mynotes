import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mynotes/screens/forgetPasswordPage.dart';
import 'package:mynotes/screens/homePage.dart';
import 'package:mynotes/screens/signupPage.dart';
import 'package:mynotes/services/NoteRepo.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        SingleChildScrollView(
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
                      Text(
                        "Login Page",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.more_vert)
                    ],
                  ),
                ),

                ///custom app bar

                ///login icons
                Container(
                  height: 300,
                  child: LottieBuilder.asset("assets/images/login.json"),
                ),

                ///login icons

                ///emailfield
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: emailLoginController,
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

                ///passwordfield
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    obscureText: obscurePassword,
                    controller: passwordLoginController,
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
                        hintText: 'Enter Your Password...'),
                  ),
                ),

                ///passwordfield
                SizedBox(
                  height: 10,
                ),

                ///LoginButton
                ElevatedButton(
                    onPressed: () async {
                      isLoading = true;
                      setState(() {});
                      var useLoginEmail = emailLoginController.text
                          .trim()
                          .toLowerCase()
                          .toString();
                      var useLoginPassword =
                          passwordLoginController.text.trim().toString();
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: useLoginEmail,
                                password: useLoginPassword);
                        final User? currentuser = await credential.user;
                        if (currentuser != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          // ignore: use_build_context_synchronously
                          NoteRepo().showSnackbar(context, e.code.toString());
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                          // ignore: use_build_context_synchronously
                          NoteRepo().showSnackbar(context, e.code.toString());
                        }
                      } finally {}
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                    )),

                /// ///LoginButton

                ///forgetpassword
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPasswordPage(),
                        ));
                  },
                  child: Text(
                    "Forget Password",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
                //////forgetpassword
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ));
                  },
                  child: Text(
                    "Don't have an account Signup",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          )),
        ),
        if (isLoading)
          ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: true,
          )
      ])),
    );
  }
}
