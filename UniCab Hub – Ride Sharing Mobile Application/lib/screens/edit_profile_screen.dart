import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/dropdown_custom.dart';
import 'package:bikerzone/widgets/input_date_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.user});
  final UserC user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();
  final bikeManufacturerController = TextEditingController();
  final bikeModelController = TextEditingController();
  final bikeYearController = TextEditingController();
  DateTime? birthdayController;
  String dropdownManufacturerValue = "Aprilia";

  @override
  void initState() {
    super.initState();
    fullnameController.text = widget.user.fullname;
    usernameController.text = widget.user.username;
    descriptionController.text = widget.user.description;
    birthdayController = widget.user.birthday;
    bikeModelController.text = widget.user.bike.model;
    bikeYearController.text = widget.user.bike.year.toString();
    fullnameController.text = widget.user.fullname;
    setState(() {
      dropdownManufacturerValue = widget.user.bike.manufacturer;
    });
  }

  void _handleDataReceived(DateTime date) {
    setState(() {
      birthdayController = date;
    });
  }

  void update() async {
    final res = await updateUser(
      fullnameController,
      usernameController,
      birthdayController,
      descriptionController,
      dropdownManufacturerValue,
      bikeModelController,
      bikeYearController.text,
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopNavigationCustom(
                leftIcon: Icons.arrow_back,
                mainText: "Edit Profile",
                rightIcon: null,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4E4E4E),
                  ),
                ),
              ),
              InputFieldCustom(
                controller: usernameController,
                hintText: null,
                labelText: "Username:",
                hide: false,
              ),
              InputFieldCustom(
                controller: fullnameController,
                hintText: null,
                labelText: "Full Name:",
                hide: false,
              ),
              InputDateCustom(
                onDataReceived: _handleDataReceived,
                labelText: "Date of Birth:",
                hintText: null,
                helpText: "Pick...",
                receivedDate: birthdayController,
                futureDateAllowed: false,
              ),
              InputFieldCustom(
                controller: descriptionController,
                hintText: null,
                labelText: "Student ID:",
                hide: false,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Vehicle Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4E4E4E),
                  ),
                ),
              ),
              DropdownCustom(
                labelText: "Manufacturer:",
                dropdownList: const [
                  "Aprilia",
                  "BMW",
                  "Ducati",
                  "Harley-Davidson",
                  "Honda",
                  "Kawasaki",
                  "KTM",
                  "Moto Guzzi",
                  "Piaggio",
                  "Suzuki",
                  "Tomos",
                  "Yamaha"
                ],
                dropdownValue: dropdownManufacturerValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownManufacturerValue = newValue!;
                  });
                },
              ),
              InputFieldCustom(
                controller: bikeModelController,
                hintText: null,
                labelText: "Model:",
                hide: false,
              ),
              InputFieldCustom(
                controller: bikeYearController,
                hintText: null,
                labelText: "Year:",
                hide: false,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: LargeButtonCustom(
                  onTap: () {
                    update();
                  },
                  btnText: "Save Changes",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
