import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_screen.dart';



class AboutScreen extends StatefulWidget
{
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}




class _AboutScreenState extends State<AboutScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(

        children: [

          //image
           Container(
            height: 230,
            child: Center(
              child: Image.asset(
                "images/logo.png",
                width: 260,
              ),
            ),
          ),

          Column(
            children: [

              //company name
              const Text(
                "Ivaya",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //about you & your company - write some info
              const Text(
                "This app has been developed by Lungelo mageba, "
                "This is the world number 1 ride sharing app. Available for all. "
                "20M+ people already use this app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                "This app has been developed by Lungelo Mageba, "
                    "This is the world number 1 ride sharing app. Available for all. "
                    "20M+ people already use this app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              //close
              ElevatedButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.black54),
                ),
              ),

            ],
          ),

        ],

      ),
    );
  }
}
