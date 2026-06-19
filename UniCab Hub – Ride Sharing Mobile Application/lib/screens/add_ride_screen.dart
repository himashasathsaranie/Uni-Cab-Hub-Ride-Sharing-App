import 'package:bikerzone/services/ride_service.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/dropdown_custom.dart';
import 'package:bikerzone/widgets/input_date_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRideScreen extends StatefulWidget {
  const AddRideScreen({Key? key});

  @override
  State<AddRideScreen> createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {
  final startingCityController = TextEditingController();
  final exactStartingPointController = TextEditingController();
  final finishingCityController = TextEditingController();
  DateTime? startingDaTController;
  DateTime? finishingDaTController;
  final nmbrOfPeopleController = TextEditingController();
  final organizersMessageController = TextEditingController();
  List<String> stopPoints = [];
  String? rideId;
  String? highway;

  String dropdownPaceValue = "Slow ride";
  String dropdownBikeValue = "-";

  void _handleStartDataReceived(DateTime date) {
    setState(() {
      startingDaTController = date;
    });
  }

  void _handleFinishDataReceived(DateTime date) {
    setState(() {
      finishingDaTController = date;
    });
  }

  bool areFieldsEmpty() {
    return startingCityController.text.isEmpty ||
        exactStartingPointController.text.isEmpty ||
        finishingCityController.text.isEmpty ||
        startingDaTController == null ||
        finishingDaTController == null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      highway = "no";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationCustom(
              leftIcon: Icons.arrow_back,
              mainText: "Add New Group Ride",
              rightIcon: null,
              isSmall: true,
              isLight: true,
            ),
            InputFieldCustom(
              controller: startingCityController,
              hintText: "e.g. Homagama",
              hide: false,
              labelText: "Starting City:",
            ),
            InputFieldCustom(
              controller: exactStartingPointController,
              hintText: "e.g. NSBM Green University",
              hide: false,
              labelText: "Exact Starting Address:",
            ),
            InputFieldCustom(
              controller: finishingCityController,
              hintText: "e.g. Nugegoda",
              hide: false,
              labelText: "Destination:",
            ),
            InputDateCustom(
              onDataReceived: _handleStartDataReceived,
              hintText: "Select...",
              setHours: true,
              futureDateAllowed: true,
              helpText: "Departure Date and Time:",
              labelText: "Departure Date and Time: **",
            ),
            InputDateCustom(
              onDataReceived: _handleFinishDataReceived,
              hintText: "Select...",
              setHours: true,
              futureDateAllowed: true,
              helpText: "Expected Arrival Time:",
              labelText: "Expected Arrival Time: **",
            ),
            DropdownCustom(
              labelText: "Travel Pace:",
              dropdownList: const ["Slow ride", 'Normal pace', 'Fast ride'],
              dropdownValue: dropdownPaceValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownPaceValue = newValue!;
                });
              },
            ),
            DropdownCustom(
              labelText: "",
              dropdownList: const ["-", "Street", "Enduro", "Mopeds", "Sports", "Quads"],
              dropdownValue: dropdownBikeValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownBikeValue = newValue!;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 5, bottom: 2),
                child: const Text(
                  "Are we traveling on the highway?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4E4E4E),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: RadioListTile(
                    title: const Text("No"),
                    value: "no",
                    groupValue: highway,
                    onChanged: (value) {
                      setState(() {
                        highway = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: RadioListTile(
                    title: const Text("Yes"),
                    value: "yes",
                    groupValue: highway,
                    onChanged: (value) {
                      setState(() {
                        highway = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 5, bottom: 2),
                    child: const Text(
                      "Add Stops (optional): **",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4E4E4E),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        stopPoints.add("");
                      });
                    },
                    child: Container(
                      width: screenWidth,
                      height: 60,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEAEA),
                        border: Border.all(color: const Color(0xFF0276B4), width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add New Stop",
                            style: TextStyle(color: Color(0xFF898989), fontSize: 16),
                          ),
                          Icon(Icons.library_add, color: Color(0xFF0276B4)),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(stopPoints.length, (index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.8,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25, right: 15, top: 5),
                              child: TextField(
                                onChanged: (newValue) {
                                  stopPoints[index] = newValue;
                                },
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF0276B4), width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF0276B4)),
                                  ),
                                  fillColor: Color(0xFFEAEAEA),
                                  filled: true,
                                  hintText: "Enter Stop:",
                                  hintStyle: TextStyle(color: Color(0xFF898989), fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                stopPoints.removeAt(stopPoints.length - 1);
                              });
                            },
                            child: index == (stopPoints.length - 1)
                                ? const Icon(
                                    Icons.delete_forever,
                                    color: Color(0xFFA41723),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            InputFieldCustom(
              controller: nmbrOfPeopleController,
              hintText: "e.g. 10 or leave empty",
              hide: false,
              labelText: "Maximum Number of People (optional):",
            ),
            InputFieldCustom(
              isTextarea: true,
              controller: organizersMessageController,
              hintText: "e.g. what to expect from the ride",
              labelText: "Organizer's Message: (optional):",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 5, bottom: 2),
                child: const Text(
                  "** Stops and departure/arrival times cannot be edited later!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 131, 131, 131),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: LargeButtonCustom(
                  onTap: areFieldsEmpty()
                      ? () {
                          Fluttertoast.showToast(
                            msg: "Fill in all required fields!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: const Color(0xFFA41723),
                            textColor: Colors.white,
                          );
                        }
                      : () async {
                          String id = await addRide(
                            startingCityController.text,
                            exactStartingPointController.text,
                            finishingCityController.text,
                            startingDaTController,
                            finishingDaTController,
                            highway == "yes" ? true : false,
                            dropdownBikeValue,
                            dropdownPaceValue,
                            nmbrOfPeopleController.text.isEmpty ? 0 : int.parse(nmbrOfPeopleController.text),
                            organizersMessageController.text,
                            stopPoints,
                          );
                          setState(() {
                            rideId = id;
                          });
                          await addRiderToThisRide(getLoggedUserReference(), id);
                          Fluttertoast.showToast(
                            msg: id.isNotEmpty ? "Ride successfully published!" : "An error occurred. Please try again.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: id.isNotEmpty ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                            textColor: Colors.white,
                          );

                          Navigator.pop(context);
                        },
                  btnText: "Publish Group Ride"),
            )
          ],
        ),
      )),
    );
  }
}