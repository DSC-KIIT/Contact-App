import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:database/models/contacts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditScreen extends StatefulWidget {
  final String id;
  EditScreen(this.id);
  @override
  _EditScreenState createState() => _EditScreenState(id);
}

class _EditScreenState extends State<EditScreen> {
  String id;
  _EditScreenState(this.id);

  String _firstName='';
  String _lastName='';
  String _phone='';
  String _email='';
  String _address='';
  String _photoUrl;

  //TextEdttingController
  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _poController = TextEditingController();
  TextEditingController _emController = TextEditingController();
  TextEditingController _adController = TextEditingController();
  bool isLoading = true;

  //Helper




  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
