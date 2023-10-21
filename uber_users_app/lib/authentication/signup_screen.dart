import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "Name must be at least 3 characters.");
    } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]").hasMatch(emailTextEditingController.text)) {
      Fluttertoast.showToast(msg: "Email address is not valid.");
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number is required.");
    } else if (phoneTextEditingController.text.length < 9) {
      Fluttertoast.showToast(msg: "Please enter a valid phone number.");
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters.");
    } else if (confirmPasswordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please confirm the password.");
    } else if (passwordTextEditingController.text != confirmPasswordTextEditingController.text) {
      Fluttertoast.showToast(msg: "Passwords do not match.");
    } else {
      saveUserInfoNow();
    }
  }

  void saveUserInfoNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, Please wait...",);
      },
    );

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        Map userMap = {
          "id": firebaseUser.uid,
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),
        };

        DatabaseReference reference = FirebaseDatabase.instance.reference().child("users");
        reference.child(firebaseUser.uid).set(userMap);

        currentFirebaseUser = firebaseUser;
        Fluttertoast.showToast(msg: "Account has been created.");
        Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Account has not been created.");
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset(
                  "images/logo.png",
                  height: 170.0, // Decreased the image size
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Register as a User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildTextField("Name", Icons.person, TextInputType.text, nameTextEditingController),
              buildTextField("Email", Icons.email, TextInputType.emailAddress, emailTextEditingController),
              buildTextField("Phone", Icons.phone, TextInputType.phone, phoneTextEditingController),
              buildPasswordField("Password", passwordTextEditingController, isPasswordVisible),
              buildPasswordField("Confirm Password", confirmPasswordTextEditingController, isConfirmPasswordVisible),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: validateForm,
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
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

  Widget buildPasswordField(String label, TextEditingController controller, bool isPasswordVisible) {
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
          prefixIcon: Icon(Icons.lock, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (label == "Password") {
                  isPasswordVisible = !isPasswordVisible;
                } else if (label == "Confirm Password") {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                }
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
