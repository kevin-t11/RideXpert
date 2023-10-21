
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../mainScreens/new_trip_screen.dart';
import '../models/user_ride_request_information.dart';

class NotificationDialogBox extends StatefulWidget {
  final UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  final audioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[800],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Image.asset(
              "images/car_logo.png",
              width: 160,
            ),
            const SizedBox(height: 10),
            const Text(
              "New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails?.originAddress ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails?.destinationAddress ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      cancelRideRequest();
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void cancelRideRequest() {
    final userRideRequestId = widget.userRideRequestDetails?.rideRequestId;
    if (userRideRequestId != null) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(userRideRequestId)
          .remove()
          .then((value) {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid!)
            .child("newRideStatus")
            .set("idle");
      }).then((value) {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid!)
            .child("tripsHistory")
            .child(userRideRequestId)
            .remove();
      }).then((value) {
        Fluttertoast.showToast(msg: "Ride Request has been Cancelled, Successfully. Restart App Now.");
      });
      Future.delayed(const Duration(milliseconds: 3000), () {
        SystemNavigator.pop();
      });
    }
  }

  void acceptRideRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid!)
        .child("newRideStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value != "idle") {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid!)
            .child("newRideStatus")
            .set("accepted");
        AssistantMethods.pauseLiveLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen()));
      } else {
        Fluttertoast.showToast(msg: "This ride request does not exist.");
      }
    });
  }
}
