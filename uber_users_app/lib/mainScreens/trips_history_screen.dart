
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../widgets/history_design_ui.dart';
import 'main_screen.dart';

class TripsHistoryScreen extends StatefulWidget {
  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}


class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
            "Trips History"
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => MainScreen()));
          },
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, i) =>
        const Divider(
          color: Colors.white,
          thickness: 2,
          height: 2,
        ),
        itemBuilder: (context, i) {
          return Card(
            color: Colors.white,
            child: HistoryDesignUIWidget(
              tripsHistoryModel: Provider
                  .of<AppInfo>(context, listen: false)
                  .allTripsHistoryInformationList[i],
            ),
          );
        },
        itemCount: Provider
            .of<AppInfo>(context, listen: false)
            .allTripsHistoryInformationList
            .length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
