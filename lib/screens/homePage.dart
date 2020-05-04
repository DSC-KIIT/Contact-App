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
      body: Container(
        child: FirebaseAnimatedList(
            query: _databaseReference,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return GestureDetector(
                onTap: () {
                  navigateToViewContacts(snapshot.key);
                },
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: snapshot.value['photoUrl'] == "empty"
                                        ? AssetImage("assets/mascot.png")
                                        : NetworkImage(
                                            snapshot.value['photoUrl']))),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${snapshot.value['firstName']} ${snapshot.value['lastName']}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto"),
                                ),
                                SizedBox(height: 4),
                                Text("${snapshot.value['phone']}")
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: navigateToAddContacts, child: Icon(Icons.add)),
    );
  }
}
