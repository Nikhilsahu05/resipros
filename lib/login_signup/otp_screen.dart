import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:resipros/screens/home_screen.dart';
import 'package:resipros/screens/users_details_screens/user_details_work_profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OTPScreen extends StatefulWidget {
  TextEditingController _otpController = TextEditingController();
  String verificationId;
  OTPScreen(this._otpController, this.verificationId);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    setState(() {});

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {});

      if (authCredential.user != null) {
        if (authCredential.additionalUserInfo!.isNewUser) {
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.success,
            title: "Account Created Successfully",
            buttons: [
              DialogButton(
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => UserWorkProfile()),
                    (Route<dynamic> route) => false),
                color: Colors.green,
                radius: BorderRadius.circular(0.0),
              ),
            ],
          ).show();
        } else {
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.success,
            title: "Hey ! Welcome Back",
            buttons: [
              DialogButton(
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false),
                color: Colors.green,
                radius: BorderRadius.circular(0.0),
              ),
            ],
          ).show();
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        print(e);
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Please Enter Valid OTP",
          style: alertStyle,
          buttons: [
            DialogButton(
              child: Text(
                "Try Again",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(left: 40.0, right: 40, top: 20),
              child: Text(
                "Please enter the 6 digit verification code we sent to you.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Roboto",
                  color: Color(0xFFF4F4F4),
                ),
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            OtpTextField(
              numberOfFields: 6,

              borderWidth: 3,
              autoFocus: true,
              focusedBorderColor: Colors.green,
              textStyle: TextStyle(
                color: Colors.white,
                fontFamily: "Roboto",
              ),
              borderColor: Color(0xFFF4F4F4),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {},
              //runs when every textfield is filled
              onSubmit: (String verificationCode) async {
                widget._otpController.text = verificationCode;
              }, // end onSubmit
            ),
            const SizedBox(
              height: 75,
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
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: widget._otpController.text);
                          print("OTP VALUE -  ${widget._otpController.text}");

                          signInWithPhoneAuthCredential(phoneAuthCredential);
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
                            Text(
                              "Confirm",
                              style: TextStyle(
                                fontFamily: "Roboto",
                              ),
                            ),
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
          "OTP",
          style: TextStyle(
            fontFamily: "Roboto",
            color: Color(0xFFF4F4F4),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF0E0D06),
      ),
    );
  }
}
