import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'otp_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  late String verificationId;

  bool showLoading = false;
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.start,
    animationDuration: Duration(milliseconds: 200),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      fontFamily: "Roboto",
      color: Colors.red,
    ),
    alertAlignment: Alignment.center,
  );
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 40.0, right: 40, top: 20),
                    child: Text(
                      "Please enter your phone number to recieve a verification code to log in and use Resipros.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Roboto",
                        color: Color(0xFFF4F4F4),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12.0, top: 35),
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
                            horizontal: 18.0, vertical: 3),
                        child: TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style: TextStyle(
                              color: Color(0xFFF4F4F4), letterSpacing: 3),
                          controller: _phoneController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefix: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text("+91"),
                            ),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Color(0xFFF4F4F4),
                            ),
                            border: InputBorder.none,
                            hintText: 'XXXXX-XXXXX',
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
                  SizedBox(
                    height: 100,
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Color(0xFFF4F4F4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent),
                              onPressed: () async {
                                if (_phoneController.text.length == 10) {
                                  await _auth.verifyPhoneNumber(
                                    phoneNumber: "+91" + _phoneController.text,
                                    verificationCompleted:
                                        (phoneAuthCredential) async {
                                      try {
                                        setState(() {
                                          showLoading = false;
                                        });
                                      } on Exception catch (e) {
                                        print(e);
                                      }
                                    },
                                    verificationFailed:
                                        (verificationFailed) async {
                                      try {
                                        setState(() {
                                          showLoading = false;
                                        });
                                        print(verificationFailed);
                                      } on Exception catch (e) {
                                        print(e);
                                      }
                                    },
                                    codeSent:
                                        (verificationId, resendingToken) async {
                                      try {
                                        setState(() {
                                          showLoading = false;
                                          Navigator.of(
                                                  context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OTPScreen(
                                                              _otpController,
                                                              verificationId)),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        });
                                      } on Exception catch (e) {
                                        print(e);
                                      }
                                    },
                                    codeAutoRetrievalTimeout:
                                        (verificationId) async {},
                                  );
                                } else {
                                  print("Not Matching");
                                  Alert(
                                    context: context,
                                    style: alertStyle,
                                    type: AlertType.info,
                                    title: "Invalid mobile number",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Try Again",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegistrationScreen()),
                                                (Route<dynamic> route) =>
                                                    false),
                                        color: Color.fromRGBO(0, 179, 134, 1.0),
                                        radius: BorderRadius.circular(0.0),
                                      ),
                                    ],
                                  ).show();
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Confirm"),
                                ],
                              ))),
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: Color(0xFF0E0D06),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LOGIN",
          style: TextStyle(
            color: Color(0xFFF4F4F4),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF0E0D06),
      ),
    );
  }
}
