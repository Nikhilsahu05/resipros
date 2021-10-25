import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class UserWorkProfile extends StatefulWidget {
  @override
  _UserWorkProfileState createState() => _UserWorkProfileState();
}

class _UserWorkProfileState extends State<UserWorkProfile> {
  TextEditingController _fullAddressTextEditingController =
      TextEditingController();
  TextEditingController _fullNameTextEditingController =
      TextEditingController();
  TextEditingController _localityTextEditingController =
      TextEditingController();
  TextEditingController _mobileTextEditingController = TextEditingController();
  TextEditingController _pincodeTextEditingController = TextEditingController();

  String tag = "UserWorkProfile + TAG";
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var _profileImage = "http://placehold.it/120x120";
  readStoreData() {
    _firebaseFirestore
        .collection("personal_information")
        .doc("profile")
        .snapshots()
        .listen((res) {
      setState(() {
        _fullNameTextEditingController.text = res.data()!["fullname"];
        _fullAddressTextEditingController.text = res.data()!["fulladdress"];
        _localityTextEditingController.text = res.data()!["locality"];
        _mobileTextEditingController.text = res.data()!["mobile"];
        _pincodeTextEditingController.text = res.data()!["pincode"];
      });
      print("$res readStoreData Success");
      print("${res.data()} readStoreData data");
      print("${res.id} readStoreData id");
    });
  }

  updateStoreData() {
    _firebaseFirestore
        .collection("personal_information")
        .doc("profile")
        .update({
          "fullname": _fullNameTextEditingController.text,
          "fulladdress": _fullAddressTextEditingController.text,
        })
        .then((value) => print("Updated"))
        .catchError((onError) {
          print(onError);
        });
  }

  bool? imagePathNull;

  File? image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePermanent = await saveImagePermanently(image.path);

      setState(() {
        this.image = imagePermanent;
      });

      if (imagePermanent.path.length != 0) {
        File image = File(imagePermanent.path);
        FirebaseStorage _storage = FirebaseStorage.instance;
        _storage
            .ref()
            .child("store_profilePicture")
            .child('profile_Picture')
            .putFile(image)
            .then((image_url) {
          print("Image Succefully Uploaded + $image_url + ");
          image_url.ref.getDownloadURL().then((url) {
            print("$url is the upload url of the image");
            setState(() {
              _profileImage = url;
            });

            _firebaseFirestore
                .collection("personal_information")
                .doc("profile")
                .update({
                  "image_url": url,
                })
                .then((value) => print("Updated"))
                .catchError((onError) {
                  print(onError);
                });
          });
        }).catchError((onError) {
          print("Some Error Found on Uploading Image +  $onError");
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  @override
  void initState() {
    readStoreData();
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("$tag ${_auth.currentUser?.phoneNumber} ");
    print("$tag ${_auth.currentUser?.displayName} ");
    print("$tag ${_auth.currentUser?.uid} ");
    print("$tag ${_auth.currentUser?.emailVerified} ");
    print("$tag ${_auth.currentUser?.displayName} ");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E0D06),
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                updateStoreData();
                FirebaseAuth _auth = FirebaseAuth.instance;
                print("$tag ${_auth.currentUser} Logging off ");
                _auth.signOut();
              },
              child: Icon(Icons.login))
        ],
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFFF4F4F4),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF0E0D06),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 30.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Image.network(
                          _profileImage,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Text(
                  "Personal Information",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.grey),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          "Full Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 3),
                            child: TextField(
                              controller: _fullNameTextEditingController,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Color(0xFFF4F4F4), letterSpacing: 3),
                              autofocus: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.supervised_user_circle_outlined,
                                  color: Color(0xFFF4F4F4),
                                ),
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF7A7A7A),
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          "Full Address",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 3),
                            child: TextField(
                              maxLines: 4,
                              controller: _fullAddressTextEditingController,
                              style: TextStyle(
                                  color: Color(0xFFF4F4F4), letterSpacing: 1),
                              autofocus: false,
                              decoration: InputDecoration(
                                errorMaxLines: 4,
                                prefixIcon: Icon(
                                  Icons.home,
                                  color: Color(0xFFF4F4F4),
                                ),
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF7A7A7A),
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "District",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 85,
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          "",
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: TextField(
                              maxLines: 4,
                              style: TextStyle(
                                  color: Color(0xFFF4F4F4), letterSpacing: 1),
                              autofocus: false,
                              decoration: InputDecoration(
                                errorMaxLines: 4,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF7A7A7A),
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(''),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          "Phone Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 65,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 23),
                            child: Text(
                              '',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                  letterSpacing: 3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 45.0, right: 45, bottom: 20),
                child: Divider(
                  thickness: 1.45,
                  color: Colors.white24,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Text(
                  "Work Information",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Text(
                          "Experience",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(child: null),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(""),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(""),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(""),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          "Expected Wages",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 3),
                            child: TextField(
                              maxLines: 1,
                              style: TextStyle(
                                  color: Color(0xFFF4F4F4), letterSpacing: 3),
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              decoration: InputDecoration(
                                labelText: "0000",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF7A7A7A),
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: null,
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          "Daily",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      updateStoreData();
                    });
                  },
                  child: Text("Update Data")),
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: ALIGN PROFILE PICTURE
