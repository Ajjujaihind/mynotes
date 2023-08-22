// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/screens/addNote.dart';
import 'package:mynotes/screens/editNote.dart';
import 'package:mynotes/screens/loginPage.dart';
import 'package:mynotes/services/NoteRepo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var collectionStream;

  @override
  void initState() {
    // TODO: implement initState

    User? user = FirebaseAuth.instance.currentUser;
    collectionStream = FirebaseFirestore.instance
        .collection('notes')
        .where('userID', isEqualTo: user!.uid)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNote(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
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
                    const Icon(Icons.menu_sharp),
                    Text(
                      "Home Page",
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

              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: collectionStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Icon(Icons.hourglass_empty_outlined),
                        );
                      }
                      if (snapshot.data!.docs.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var noteid = snapshot.data!.docs[index].id;
                              var note = snapshot.data!.docs[index]['note'];

                              return InkWell(
                                onLongPress: () async {
                                  NoteRepo().showSnackbar(
                                      context, "Your note is deleted");
                                  await FirebaseFirestore.instance
                                      .collection("notes")
                                      .doc(noteid.toString())
                                      .delete();
                                  // ignore: use_build_context_synchronously
                                },
                                child: Card(
                                  color: Colors.brown.shade200,
                                  child: ListTile(
                                    title: Text(
                                        snapshot.data!.docs[index]['note']),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditNote(
                                                              note, noteid)));
                                            },
                                            child: Icon(Icons.edit)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
