// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/physics.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: "Registration",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static int rmnd = 0;

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Registration Form';

    return MaterialApp(
        title: appTitle,
        home: Scaffold(
            appBar: AppBar(
              title: const Text(appTitle),
            ),
            body: const MyCustomForm(),
            bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.contact_phone), label: 'Contact Us'),
                  // BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
                ],
                onTap: (rmnd) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contactus()),
                  );
                })));
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _mobilecontroller = TextEditingController();
  TextEditingController _fbidcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Your Name';
                  }
                  return null;
                },
                controller: _namecontroller,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter Your Name",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: TextFormField(
                controller: _emailcontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Your Email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter Your Email",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: TextFormField(
                controller: _mobilecontroller,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Your Mobile Number';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  hintText: "Enter Your Mobile Number",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Your Facebook Id';
                  }
                  return null;
                },
                controller: _fbidcontroller,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Facebook id",
                  hintText: "Paste link to your Facebook Profile",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Processing Data')),
                    // );
                    _create();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
    // ignore: dead_code
  }

  Future _create() async {
    final userCollection = FirebaseFirestore.instance.collection("Users");
    final docref = userCollection.doc();
    await docref.set({
      "name": _namecontroller.text,
      "Email": _emailcontroller.text,
      "mobile": _mobilecontroller.text,
      "facebook_id": _fbidcontroller.text,
    });
  }
}

class Contactus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactusState();
  }
}

class ContactusState extends State<Contactus> {
  List<Map<String, dynamic>> Data = [];

  Future getdata() async {
    await FirebaseFirestore.instance
        .collection("contact")
        .get()
        .then((snapshot) => snapshot.docs.forEach((contact) {
              print(contact);
            }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('contact').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document) {
                // ignore: avoid_unnecessary_containers
                return Container(
                  height: 300,
                  width: 300,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(document['dp']),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text("name :${document["name"]}"),
                        Text("mobile :${document["mobile"]}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
