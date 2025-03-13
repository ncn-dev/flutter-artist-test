import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _inputInfor = GlobalKey<FormState>();
  final name = TextEditingController();
  final nation = TextEditingController();
  final performance = TextEditingController();

  void addArtistToFirestore() async{
    if(_inputInfor.currentState!.validate()){
      try{
        await FirebaseFirestore.instance.collection('Artists').add({
          'name': name.text,
          'nationality': nation.text,
          'performance': performance.text,

        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Artist added successfully!")),
        );
        name.clear();
        nation.clear();
        performance.clear();
        Navigator.pop(context);
      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add artist: $e")),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Artist Information",
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
                      backgroundColor: Color(0xFF66CCFF),
                    ) ,
                    onPressed: () {
                      addArtistToFirestore();
                    },
                    child: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_task, color: Colors.black, size: 20),
                          SizedBox(width: 20),
                          Text("Add Your Information",style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),),

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
