import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_drivers_app/authentication/signup_screen.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'forgot_pw_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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
      loginDriverNow();
    }
  }

  loginDriverNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, Please wait...",);
      },
    );

    try {
      final UserCredential userCredential = await fAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
        driversRef.child(firebaseUser.uid).once().then((driverKey) {
          final snap = driverKey.snapshot;
          if (snap.value != null) {
            currentFirebaseUser = firebaseUser;
            Fluttertoast.showToast(msg: "Login Successful.");
            Navigator.push(context, MaterialPageRoute(builder: (c) => const MySlashScreen()));
          } else {
            Fluttertoast.showToast(msg: 'No record exists with this email');
            fAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c) => const MySlashScreen()));
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
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  "images/logo1.png",
                  height: 200, // Decreased the image size
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Login as Driver",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildTextField("Email", Icons.email, TextInputType.emailAddress, emailTextEditingController),
              buildPasswordField("Password", passwordTextEditingController, isPasswordVisible),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordPage();
                        }));
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       isPasswordVisible = !isPasswordVisible;
                    //     });
                    //   },
                    //   child:
                    //   Text(
                    //     isPasswordVisible ? 'Hide Password' : 'Show Password',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
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
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const SignUpScreen()));
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
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          labelStyle: const TextStyle(
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
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          prefixIcon: const Icon(Icons.lock, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                this.isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}


