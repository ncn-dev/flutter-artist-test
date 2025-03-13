import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editpage extends StatefulWidget {
  final String documentId ;

  const Editpage({super.key, required this.documentId});
  
  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
   final _inputInfor = GlobalKey<FormState>();
  final name = TextEditingController();
  final nation = TextEditingController();
  final performance = TextEditingController();
  @override
  void initState() {
       super.initState();
      _loadArtistData();
  }
   void _loadArtistData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Artists')
          .doc(widget.documentId)
          .get();

      if (doc.exists) {
        setState(() {
          name.text = doc['name'];
          nation.text = doc['nationality'];
          performance.text = doc['performance'];
        });
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }


  void _updateArtist() async{
    if (_inputInfor.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('Artists')
            .doc(widget.documentId)
            .update({
          'name': name.text,
          'nationality': nation.text,
          'performance': performance.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Updated Successfully!")),
        );
        Navigator.pop(context);
      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update Failed: $e")),
        );
      }
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Artist Information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _inputInfor, 
            child: Column(
              children: [
                  buildTextField(name, "Name", "Please enter your name"),
                  buildTextField(nation, "Nationality", "Please enter your Nationality"),
                  buildTextField(performance, "Performance", "Please enter your Performance"), 
                  SizedBox(height: 20),
                  ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ) ,
                    onPressed: () {
                      _updateArtist();
                    },
                    child: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.border_color, color: Colors.black, size: 20),
                          SizedBox(width: 20),
                          Text("Update Your Edit ",style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),),

                        ],
                      ),
                    )),  
              ]
          )),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    String validationMsg,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return validationMsg;
          } else {
            return null;
          }
        },
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }
}
