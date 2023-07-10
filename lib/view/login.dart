import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Shopping App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'phone number',
                    prefix: Padding(padding: EdgeInsets.all(2),child: Text('+91'),),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,

                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Visibility(
                  visible: otpVisibility,
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'OTP',
                      prefix: Padding(padding: EdgeInsets.all(4),child: Text(""),)
                    ),
                    maxLength: 6,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () {
                      if (kDebugMode) {
                        print(phoneNumberController.text);
                      }
                      if (kDebugMode) {
                        print(passwordController.text);
                      }
                      if (otpVisibility) {
                        verifyOTP();
                      } else {
                        loginWithPhone();
                      }
                    },
                    child:  Text(
                      otpVisibility ? "verify":"Login",
                      style: const TextStyle(fontSize: 20),
                    ),
                  )),
            ],
          )),
    );
  }

  void verifyOTP() async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: passwordController.text);
    await auth.signInWithCredential(credential).then((value) {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
    }).whenComplete(() {
      if (user != null) {
        Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "your login is failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }


  void loginWithPhone() async{
    auth.verifyPhoneNumber(
      phoneNumber: "+91${phoneNumberController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print(e.message);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
