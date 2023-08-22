import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/screens/loginPage.dart';
import 'package:mynotes/services/NoteRepo.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController addNewNoteController = TextEditingController();
  User? currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
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
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios)),
                      Text(
                        "New Note",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          },
                          child: Icon(Icons.logout))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                ///custom app bar
                TextFormField(
                  controller: addNewNoteController,
                  decoration: InputDecoration(
                      hintText: 'Enter Your Note......',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),

                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var note = addNewNoteController.text.trim().toString();
                      if (note.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection("notes")
                            .doc()
                            .set({
                          'createdAt': DateTime.now(),
                          'note': note,
                          'userID': currentUser!.uid
                        }).then((value) {
                          NoteRepo().showSnackbar(context, "Your note is Add");
                          print("Note Added");
                        }).catchError(
                                (error) => print("Failed to add note: $error"));
                        ;
                      } else {}
                    },
                    child: Text("Add Note"))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
