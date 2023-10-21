import 'dart:async';

import 'package:flutter/material.dart';

import '../authentication/login_screen.dart';
import '../global/global.dart';
import '../mainScreens/main_screen.dart';

class MySlashScreen extends StatefulWidget {
  const MySlashScreen({Key? key}) : super(key: key);

  @override
  State<MySlashScreen> createState() => _MySlashScreenState();
}

class _MySlashScreenState extends State<MySlashScreen> {
  startTimer()
  {
    Timer(const Duration(seconds: 3), ()async
    {
      if(await fAuth.currentUser !=null)
        {
          currentFirebaseUser = fAuth.currentUser;
          Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
        }
      else
      {
        //send user to main screen
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }
  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        color: Colors.blue,
        child: const Center(
          child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),

              Text(
                "RideXpert",
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )
              )
            ],
      )
      )

      ),
    );
  }
}
