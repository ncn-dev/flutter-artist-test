import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_artist_test/addPage.dart';
import 'package:flutter_artist_test/editPage.dart';
import 'firebase_options.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CollectionReference artistsCollection = FirebaseFirestore.instance.collection(
    "Artists",
  );
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Artists List",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2F4F4F),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color(0xFF2F4F4F),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: StreamBuilder(
        stream: artistsCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("NO!! data");
          } else {
            var artists = snapshot.data!.docs;
            return ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: artists.length,
              itemBuilder: (context, index) {
                var eachArtists = artists[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children:[
                            SlidableAction(
                              onPressed: (context){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Editpage(documentId:eachArtists.id)));
                              },
                              backgroundColor: Color(0xFFFF9933),
                              borderRadius: BorderRadius.circular(10),
                              icon: Icons.edit,
                              label: 'Edit',
                              ),
                               SlidableAction(
                              onPressed: (context) async{
                               try {
                                  
                                  await FirebaseFirestore.instance
                                      .collection('Artists')
                                      .doc(eachArtists.id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Deleted Successfully!")),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Delete Failed: $e")),
                                  );
                                }
                              },
                              backgroundColor: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              foregroundColor: Colors.black,
                              icon: Icons.delete,
                              label: 'Delete',
                              ),
                          ],
                          ),
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 350,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16, top:15 ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Name Artists: ${eachArtists['name']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Nationality: ${eachArtists['nationality']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
