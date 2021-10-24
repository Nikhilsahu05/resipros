import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resipros/login_signup/registration_screen.dart';
import 'package:resipros/screens/users_details_screens/user_details_work_profile.dart';

class ValidateScreen extends StatefulWidget {
  @override
  State<ValidateScreen> createState() => _ValidateScreenState();
}

class _ValidateScreenState extends State<ValidateScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isUserLogged = false;

  validate() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          _isUserLogged = true;
        });
      } else {
        setState(() {
          _isUserLogged = false;
        });
      }
    });
  }

  @override
  void initState() {
    validate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isUserLogged ? UserWorkProfile() : RegistrationScreen();
  }
}
