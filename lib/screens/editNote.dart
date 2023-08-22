import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/screens/loginPage.dart';
import 'package:mynotes/services/NoteRepo.dart';

class EditNote extends StatefulWidget {
  String note;
  String noteid;
  EditNote(
    this.note,
    this.noteid,
  );

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController updateNoteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
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
                    Text(
                      "Edit Note",
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
                        child: const Icon(Icons.logout)),
                  ],
                ),
              ),

              ///custom app bar
              TextFormField(
                controller: updateNoteController..text = "${widget.note}",
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
                    await FirebaseFirestore.instance
                        .collection("notes")
                        .doc(widget.noteid.toString())
                        .update({
                      'note': updateNoteController.text.trim().toString()
                    }).then((value) {
                      NoteRepo().showSnackbar(context, "Your note is Updated");
                      print("Note Updated");
                    }).catchError(
                            (error) => print("Failed to Update Note: $error"));
                  },
                  child: Text("Update Note"))
            ],
          ),
        ),
      )),
    );
  }
}

class $ {}
