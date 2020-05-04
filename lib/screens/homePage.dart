import 'package:database/screens/addContacts.dart';
import 'package:database/screens/viewScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  FirebaseUser user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SigninPage");
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  navigateToAddContacts() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return AddContact();
    }));
  }

  navigateToViewContacts(id) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ViewScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text('Contacts App'),
      ),
      drawer: Drawer(
        child: !isSignedIn
            ? CircularProgressIndicator()
            : ListView(children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text('${user.displayName}'),
                  accountEmail: Text('${user.email}'),
                  decoration: BoxDecoration(color: Colors.red),
                  currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 50,
                      backgroundImage: AssetImage("assets/mascot.png")),
                ),
                ListTile(
                  title: Text('Contact App'),
                  trailing: Icon(Icons.contacts),
                ),
                Divider(thickness: 2),
                ListTile(
                  title: Text('Sign Out'),
                  trailing: Icon(Icons.delete),
                  onTap: signOut,
                ),
                ListTile(
                  title: Text('Close'),
                  trailing: Icon(Icons.close),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ]),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddContacts,
        child: Icon(Icons.add)
        ),
    );
  }
}
