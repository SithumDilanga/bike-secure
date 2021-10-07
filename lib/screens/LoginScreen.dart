import 'package:bike_secure/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 170.0),
              Text(
                'Login Here',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 50.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue[800],
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28.0, 16.0, 28.0, 16.0),
                  child: Text(
                    'LOG IN',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                onPressed: () async {
                  dynamic result = await signInWithEmailAndPassword(
                      emailTextEditingController.text,
                      passwordTextEditingController.text);

                  if (result == null) {
                    // show an error message
                    Fluttertoast.showToast(
                      msg: 'Could not sign in!',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  } else {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Home()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------- Sign In with email and Password ---------------
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'User not found');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      }
    }
  }
}
