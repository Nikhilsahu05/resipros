import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resipros/constants/constants.dart';

class UserWorkProfile extends StatefulWidget {
  @override
  _UserWorkProfileState createState() => _UserWorkProfileState();
}

class _UserWorkProfileState extends State<UserWorkProfile> {
  File? image;
  var profileImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  String mobileNumber = "";

  Future getData() async {
    FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseFirestore
        .collection('personal_information')
        .doc("profile")
        .get()
        .then((res) {
      print("User Work Profile ${res.data()!["mobile"]}");
      setState(() {
        mobileNumber = res.data()!["mobile"];
        print(mobileNumber);
      });
    });
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return print("Image is null");
    } on Exception catch (e) {
      print("Get Image error $e");

      setState(() {
        this.image = File(image!.path);
        ;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  ///////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokyBlack,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Personal Information",
          style: TextStyle(
            fontFamily: fontFamilyRoboto,
            fontSize: 25,
            color: cultured,
          ),
        ),
        elevation: 8,
        backgroundColor: smokyBlack,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    getImage(ImageSource.gallery);
                  },
                  child: ClipOval(
                    child: CircleAvatar(
                      child: Image.network("$profileImage"),
                      backgroundColor: Colors.black,
                      maxRadius: 55,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                  color: cultured,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Full Name",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  color: cultured,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$mobileNumber",
                    style: TextStyle(
                        color: davysGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamilyRoboto),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                  color: cultured,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Full Address",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: cultured,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Pin Code",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cultured,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          "INDIA",
                          style: TextStyle(
                              color: davysGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontFamilyRoboto),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: cultured,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "State",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cultured,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "District",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                  color: cultured,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Locality",
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    primary: Colors.blue.shade600,
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.more_horiz),
                      Text(
                        "Next",
                        style: TextStyle(
                            fontFamily: fontFamilyRoboto,
                            letterSpacing: 2.5,
                            fontSize: 18,
                            color: cultured,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: ALIGN PROFILE PICTURE
