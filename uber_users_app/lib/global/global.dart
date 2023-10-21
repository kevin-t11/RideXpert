import 'package:firebase_auth/firebase_auth.dart';

import '../models/direction_details_info.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAC3dzGTc:APA91bHqjntQ5s2Xy3zi_mn765sEbZIrPZU9Jf9EqnAOlqlfI4MpewPnLWBeylxjQclqX3jtvRTilXD1hS5UfSmzANu9bucByxxY2Nz4-N8Q8NKOVCTzFWhHVBgt4wUnsY-bJSjQW-lK";
String userDropOffAddress = "";
String driverCarDetails="";
String driverName="";
String driverPhone="";
double countRatingStars=0.0;
String titleStarsRating="";