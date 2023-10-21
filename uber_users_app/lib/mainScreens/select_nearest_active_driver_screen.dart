import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget
{
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  _SelectNearestActiveDriversScreenState createState() => _SelectNearestActiveDriversScreenState();
}



class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen>
{
  String fareAmount = "";

  getFareAmountAccordingToVehicleType(int index)
  {
    if(tripDirectionDetailsInfo != null)
    {
      if(dList[index]["car_details"]["type"].toString() == "bike")
      {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) /1.5).toStringAsFixed(1);
      }
      if(dList[index]["car_details"]["type"].toString() == "uber-x") //means executive type of car - more comfortable pro level
          {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) *1.1).toStringAsFixed(1);
      }
      if(dList[index]["car_details"]["type"].toString() == "uber-go") // non - executive car - comfortable
          {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toString();
      }
    }
    return fareAmount;
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Nearest Online Drivers",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
              Icons.close, color: Colors.white
          ),
          onPressed: ()
          {
            //delete/remove the ride request from database
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(msg: "you have cancelled the ride request.");

            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index)
        {
          return GestureDetector(
            onTap: ()
            {
              setState(() {
                chosenDriverId = dList[index]["id"].toString();
              });
              Navigator.pop(context, "driverChoosed");
            },
            child: Card(
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.blue,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "images/" + dList[index]["car_details"]["type"].toString() + ".png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["name"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      dList[index]["car_details"]["car_model"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SmoothStarRating(
                      rating: dList[index]["ratings"] == null ? 0.0 : double.parse(dList[index]["ratings"]),
                      color: Colors.blue,
                      borderColor: Colors.blue,
                      allowHalfRating: true,
                      starCount: 5,
                      size: 15,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "R" + getFareAmountAccordingToVehicleType(index),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.distance_text! : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
