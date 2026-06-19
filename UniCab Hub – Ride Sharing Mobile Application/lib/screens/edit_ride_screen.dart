import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/services/ride_service.dart';
import 'package:bikerzone/widgets/dropdown_custom.dart';
import 'package:bikerzone/widgets/input_date_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class EditRideScreen extends StatefulWidget {
  const EditRideScreen({Key? key, required this.ride});
  final Ride ride;

  @override
  State<EditRideScreen> createState() => _EditRideScreenState();
}

class _EditRideScreenState extends State<EditRideScreen> {
  final startingCityController = TextEditingController();
  final exactStartingPointController = TextEditingController();
  final finishingCityController = TextEditingController();
  DateTime? startingDateTimeController;
  DateTime? finishingDateTimeController;
  final bikeTypeController = TextEditingController();
  final paceController = TextEditingController();
  final numberOfPeopleController = TextEditingController();
  final organizersMessageController = TextEditingController();
  List<dynamic> stopPoints = [];
  String? highway;
  String dropdownPaceValue = "Slow ride";
  String dropdownBikeValue = "-";
  List<TextEditingController> stopPointsControllers = [];

  bool areFieldsEmpty() {
    return startingCityController.text.isEmpty ||
        exactStartingPointController.text.isEmpty ||
        finishingCityController.text.isEmpty ||
        startingDateTimeController == null ||
        finishingDateTimeController == null;
  }

  void update() async {
    final res = await updateRide(
        startingCityController,
        exactStartingPointController,
        finishingCityController,
        startingDateTimeController!,
        finishingDateTimeController!,
        highway == "yes" ? true : false,
        dropdownBikeValue,
        dropdownPaceValue,
        numberOfPeopleController,
        organizersMessageController,
        stopPoints,
        widget.ride.id,
        widget.ride.userId);

    Fluttertoast.showToast(
      msg: res == true ? "Changes saved." : "An error occurred. Please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
      textColor: Colors.white,
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _handleStartDataReceived(DateTime date) {
    setState(() {
      startingDateTimeController = date;
    });
  }

  void _handleFinishDataReceived(DateTime date) {
    setState(() {
      finishingDateTimeController = date;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      startingCityController.text = widget.ride.startingPoint;
      exactStartingPointController.text = widget.ride.exactStartingPoint;
      finishingCityController.text = widget.ride.finishingPoint;
      startingDateTimeController = widget.ride.startDateTime;
      finishingDateTimeController = widget.ride.finishDateTime;
      numberOfPeopleController.text = widget.ride.maxPeople.toString();
      organizersMessageController.text = widget.ride.message;
      stopPoints = widget.ride.stopPoints;
      setState(() {
        highway = widget.ride.highway == true ? "yes" : "no";
        dropdownPaceValue = widget.ride.pace;
        dropdownBikeValue = widget.ride.acceptType;
      });

      for (int i = 0; i < stopPoints.length; i++) {
        TextEditingController controller = TextEditingController();
        controller.text = stopPoints[i];
        stopPointsControllers.add(controller);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopNavigationCustom(
                leftIcon: Icons.arrow_back,
                mainText: "Edit Ride",
                rightIcon: Icons.delete,
                isLight: true,
                isSmall: true,
                rightOnTap: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  final res = await deleteRide(widget.ride.id);
                  Fluttertoast.showToast(
                    msg: res == true ? "Ride successfully deleted." : "An error occurred. Please try again.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                    textColor: Colors.white,
                  );
                },
              ),
              InputFieldCustom(
                controller: startingCityController,
                hintText: "e.g. Karlovac",
                hide: false,
                labelText: "Starting City:",
              ),
              InputFieldCustom(
                controller: exactStartingPointController,
                hintText: "e.g. Street Some 23, Bakery Bread",
                hide: false,
                labelText: "Exact Starting Point Address:",
              ),
              InputFieldCustom(
                controller: finishingCityController,
                hintText: "e.g. Osijek",
                hide: false,
                labelText: "Destination:",
              ),
              InputDateCustom(
                onDataReceived: _handleStartDataReceived,
                hintText: "Pick...",
                setHours: true,
                enabled: false,
                futureDateAllowed: true,
                helpText: "Date and Time of Departure:",
                labelText: "Date and Time of Departure:",
                receivedDate: startingDateTimeController,
              ),
              InputDateCustom(
                onDataReceived: _handleFinishDataReceived,
                hintText: "Pick...",
                enabled: false,
                setHours: true,
                futureDateAllowed: true,
                helpText: "Expected Time of Arrival:",
                labelText: "Expected Time of Arrival:",
                receivedDate: finishingDateTimeController,
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
                dropdownList: const ["-", "Road", "Enduro", "Mopeds", "Sports", "Quads"],
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
                    "Traveling on the highway?",
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
                        "Stops (optional):",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4E4E4E),
                        ),
                      ),
                    ),
                    Column(
                      children: List.generate(stopPointsControllers.length, (index) {
                        return Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25, right: 15, top: 5),
                                child: TextField(
                                  controller: stopPointsControllers[index],
                                  onChanged: (newValue) {
                                    stopPoints[index] = newValue;
                                  },
                                  enabled: false,
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
                                    hintText: "",
                                    hintStyle: TextStyle(color: Color(0xFF898989), fontSize: 16),
                                  ),
                                ),
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
                controller: numberOfPeopleController,
                hintText: "e.g. 10 or leave empty",
                hide: false,
                labelText: "Maximum Number of People (0 = no limit):",
              ),
              InputFieldCustom(
                isTextarea: true,
                controller: organizersMessageController,
                hintText: "e.g. what to expect from the ride",
                labelText: "Organizer's Message: (optional)",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 5),
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
                        : () {
                            update();
                          },
                    btnText: "Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
