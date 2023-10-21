import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_users_app/authentication/signup_screen.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'forgot_pw_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isPasswordVisible = false;

  void validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginUserNow();
    }
  }

  void loginUserNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, Please wait...",);
      },
    );

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("users");
        driversRef.child(firebaseUser.uid).once().then((driverKey) {
          final snap = driverKey.snapshot;
          if (snap.value != null) {
            currentFirebaseUser = firebaseUser;
            Fluttertoast.showToast(msg: "Login Successful.");
            Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
          } else {
            Fluttertoast.showToast(msg: "No record exists with this email.");
            FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
          }
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error Occurred during Login.");
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png",
                height: 170.0
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Login as User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildTextField("Email", Icons.email, TextInputType.emailAddress, emailTextEditingController),
              buildPasswordField("Password", Icons.lock, passwordTextEditingController, isPasswordVisible),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ForgotPasswordPage();
                        }));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: validateForm,
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Don't have an Account? Sign Up Here",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, IconData icon, TextInputType keyboardType, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(String label, IconData icon, TextEditingController controller, bool isPasswordVisible) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        obscureText: !isPasswordVisible,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                this.isPasswordVisible = !this.isPasswordVisible;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
