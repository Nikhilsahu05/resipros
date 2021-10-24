import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resipros/constants/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.amber,
        child: Center(
            child: InkWell(
          onTap: () async {
            print(_auth.currentUser);
            _auth.signOut();
            print(_auth.currentUser);
          },
          child: Text(
            "$underDevelopment",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
            ),
            textAlign: TextAlign.center,
          ),
        )),
      ),
    );
  }
}
