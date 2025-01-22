import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_app/views/apppointment_screen.dart';
import 'package:hospital_app/views/home_screen.dart';
import 'package:hospital_app/views/login.dart';
import 'package:hospital_app/views/transaction_booked.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';
import './bottom_navigation_bar.dart';
import '../widgets/main_info_hospital.dart';
import '../widgets/doctor_booking_card.dart';
import '../widgets/review_card.dart';
import "../widgets/doctor_details_bottom_sheet.dart";
import '../widgets/hospital_image_pageview.dart';
import './dateCalender.dart';
import '../controllers/hostpital_detaill_screen.dart';
import '../utils/app_constant.dart';
import '../utils/helper_class.dart';
import "package:flutter/services.dart";
import 'package:easebuzz_flutter_sdk/easebuzz_flutter_sdk.dart';

class DoctorBookingForm extends StatefulWidget {
  @override
  State<DoctorBookingForm> createState() => _DoctorBookingFormState();
}

class _DoctorBookingFormState extends State<DoctorBookingForm> {
  static MethodChannel _channel = MethodChannel('easebuzz');
  final arguments = Get.arguments;
  final List<String> genderOptions = [
    "Male",
    "Female",
    "Non-Binary",
    "Prefer not to say",
    "Other"
  ];
  final List<String> states = [
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Lakshadweep',
    'Ladakh',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Puducherry',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];
  final HospitalDetailsController controller =
      Get.find<HospitalDetailsController>(tag: "HospitalDetailScreen");
  final storage = GetStorage();
  TextEditingController _patientName = TextEditingController();
  TextEditingController _patientAge = TextEditingController();
  TextEditingController _patientPhone = TextEditingController();
  TextEditingController _patientGender = TextEditingController();
  TextEditingController _patientAddress = TextEditingController();
  TextEditingController _patientCity = TextEditingController();
  TextEditingController _patientPincode = TextEditingController();
  TextEditingController _patientComments = TextEditingController();
  TextEditingController _patientFatherName = TextEditingController();
  TextEditingController _patientState = TextEditingController();
  FocusNode _genderFocusNode = FocusNode();
  FocusNode _stateFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isForSomeoneElse = false;
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.75, // oppen  75% of the screen height
          child:
              DocterDetailsBottomSheet(slug: controller.doctorDetails["slug"]),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void autoFillForm(Map<String, dynamic> userDetails) {
    _patientName.text = userDetails["fullName"] ?? "";
    _patientAge.text = (userDetails["age"] ?? "").toString();
    _patientPhone.text = userDetails["phone"] ?? "";
    _patientGender.text = userDetails["gender"] ?? "";
    _patientAddress.text = userDetails["address"]?["street"] ?? "";
    _patientCity.text = userDetails["address"]?["city"] ?? "";
    _patientPincode.text =
        (userDetails["address"]?["pincode"] ?? "").toString();
    _patientComments.text = "";
    _patientFatherName.text = userDetails["fatherName"] ?? "";
    _patientState.text = userDetails["address"]?["state"] ?? "";
  }

  void cleanForm() {
    _patientName.text = "";
    _patientAge.text = "";
    _patientPhone.text = "";
    _patientGender.text = "";
    _patientAddress.text = "";
    _patientCity.text = "";
    _patientPincode.text = "";
    _patientComments.text = "";
    _patientFatherName.text = "";
    _patientState.text = "";
  }

  Widget DropDownList(String selectedValue, List<String> options,
      TextEditingController controller, String hintText, FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 36,
        child: DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select an option";
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          dropdownColor: Colors.white,
          isDense: true,
          borderRadius: BorderRadius.circular(10),
          value: selectedValue.isNotEmpty ? selectedValue : null,
          onChanged: (value) {
            controller.text = value!;
            // Remove error message when the user selects an option
            focusNode.requestFocus();
          },
          hint: Text(
            hintText,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Color.fromRGBO(150, 150, 150, 1),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          items: options.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Color.fromRGBO(37, 37, 37, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String convertTo12HourFormat(String time24) {
    List<String> parts = time24.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    String period = hour >= 12 ? "PM" : "AM";
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12;
    String formattedTime =
        "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
    return formattedTime;
  }

  Future<bool> createAppointment() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> patient = {};

      // Adding values from the controllers to the payload
      patient["name"] = _patientName.text.trim();
      patient["age"] = int.tryParse(_patientAge.text.trim()) ?? 0;
      patient["phone"] = _patientPhone.text.trim();
      patient["gender"] = _patientGender.text.trim();
      patient["bloodGroup"] =
          storage.read("userDetails")["bloodGroup"] ?? "AB+";
      patient["address"] = {
        "street": _patientAddress.text.trim(),
        "city": _patientCity.text.trim(),
        "state": _patientState.text.trim(),
        "pincode": int.tryParse(_patientPincode.text.trim()),
      };
      patient["comments"] = _patientComments.text.trim();
      patient["fatherName"] = _patientFatherName.text.trim();
      patient["email"] = storage.read("userDetails")["email"] ?? "";
      Map<String, dynamic> payload = {};
      payload["patient"] = patient;
      payload["doctor"] = controller.doctorDetails["slug"];
      payload["hospital"] = controller.hospitalDetails["slug"];
      DateTime selectedDate =
          DateTime.parse(arguments["selectedDate"].toIso8601String());

      List<String> timeParts = arguments["selectedSlot"].split(":");
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      DateTime combinedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hours,
        minutes,
      );
      String dateTimeString = combinedDateTime.toLocal().toString();
      payload["dateTime"] = dateTimeString;

      print(payload);
      String access_key = await controller.createAppointment(payload);
      print("dfafd->>>>>>>>>>>>>>>>");
      print(access_key);

      // String access_key = "Access key generated by the Initiate Payment API";
      String pay_mode = "test";
      // Object parameters = {"access_key": access_key, "pay_mode": pay_mode};
      // print("acces_key");
      // print(access_key);

      // final Map response =
      //     await _channel.invokeMethod("payWithEasebuzz", parameters);

      // String result = response['result'];
      // print(result);
      // Map<Object?, Object?> detailed_response = response['payment_response'];
      final EasebuzzFlutterSdk _easebuzzFlutterPlugin = EasebuzzFlutterSdk();
      try {
        // Invoke the method on the platform to initiate payment

        final paymentResponse =
            await _easebuzzFlutterPlugin.payWithEasebuzz(access_key, pay_mode);
        print(paymentResponse);
        if (paymentResponse.toString() == "payment_successfull") {
          Get.to(AppointmentScreen());
          return true;
        }
      } on PlatformException catch (e) {
        return false;
      }

      return false;
      // print(detailed_response);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = storage.read("userDetails");
    String state = "";
    String gender = "";
    if (userDetails == null) {
      // Trigger navigation after the first frame is drawn
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Unauthorized", "Please Login to Continue");
        Get.to(const LoginScreen());
      });
      // return; // Return early, do not continue with form autofill
    } else {
      if (userDetails["address"] != null) {
        state = userDetails["address"]?["state"] ?? "";
      }
      if (userDetails["gender"] != null) {
        gender = userDetails["gender"];
      }
      autoFillForm(userDetails);
    }
    // final userDetails = storage.read("userDetails");
    return Scaffold(
        // backgroundColor: Colors.white,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            fit: StackFit.loose,
            children: [
              HospitalImagePageview(),
              Column(
                children: [
                  MainInfoOfHospital(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showFilterBottomSheet(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppColors.doctorScreenBackgroudColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Ensures the image follows the same border radius
                                    child: Image.network(
                                      (controller.doctorDetails?["image"]
                                                  ?.isEmpty ??
                                              true)
                                          ? "${AppConstant.ImageDomain}/doctor-fallback.jpg"
                                          : "${AppConstant.ImageDomain}/${controller.doctorDetails["image"]}",
                                      fit: BoxFit.cover,
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.doctorDetails["honorific"]} ${StringFunctions.convertToTitleCase(controller.doctorDetails["name"])}",
                                      style: GoogleFonts.poppins(
                                          height: 24 / 16,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "${controller.doctorDetails["department"]} • ${controller.doctorDetails["experienceCount"] ?? 0}+ Years Experience",
                                      style: GoogleFonts.poppins(
                                          color: Color.fromRGBO(0, 0, 0, 0.6),
                                          height: 16 / 12,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  width: 12.08,
                                  height: 7.24,
                                  child: SvgPicture.asset(
                                    "assets/images/arrow_down.svg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Text(
                          "${DateFormat('EEE, MMM dd, yyyy').format(arguments["selectedDate"])} • ${convertTo12HourFormat(arguments["selectedSlot"])}",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 30 / 14),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.doctorScreenBackgroudColor),
                            child: Row(
                              children: [
                                Container(
                                  height: 12,
                                  child: SvgPicture.asset(
                                    "assets/images/arrow_back.svg",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                Text("Change Slot",
                                    style: GoogleFonts.poppins(
                                        color: Color.fromRGBO(27, 43, 58, 1),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        height: 30 / 14))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Toggle Switch
                          Row(
                            children: [
                              Transform.scale(
                                scaleX: 0.8,
                                scaleY: 0.8,
                                child: Switch(
                                  activeColor: Colors
                                      .white, // Thumb color when the switch is ON
                                  activeTrackColor: AppColors
                                      .primary, // Track color when the switch is ON
                                  inactiveThumbColor: Color.fromRGBO(
                                      208,
                                      218,
                                      227,
                                      1), // Thumb color when the switch is OFF
                                  inactiveTrackColor: Colors.grey.shade100,
                                  value: isForSomeoneElse,
                                  onChanged: (value) {
                                    setState(() {
                                      isForSomeoneElse = value;
                                    });
                                    if (value == true) {
                                      cleanForm();
                                    } else {
                                      autoFillForm(userDetails);
                                    }
                                  },
                                ),
                              ),
                              Text("For Someone Else",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      height: 20 / 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 10),

                          // Patient Name
                          buildTextField(
                              "Patient Name", _patientName, "Patient Name"),
                          SizedBox(height: 10),

                          // Age and Gender
                          Row(
                            children: [
                              Expanded(
                                child: buidlNumberFeild(
                                    "Age", _patientAge, "Age", 3),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropDownList(
                                        gender,
                                        genderOptions,
                                        _patientGender,
                                        "Select Gender",
                                        _genderFocusNode)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // Father/Husband Name
                          buildTextField("Father/Husband Name",
                              _patientFatherName, "Father/Husband Name"),
                          SizedBox(height: 10),
                          buidlNumberFeild("Phone Number", _patientPhone,
                              "Phone Number", 10),
                          SizedBox(height: 10),
                          buildExpandableField(
                              "Address", _patientAddress, "Address"),

                          // TextField(
                          //   decoration: InputDecoration(
                          //     labelText: "Address",
                          //     border: OutlineInputBorder(),
                          //   ),
                          //   maxLines: 2,
                          // ),
                          SizedBox(height: 10),

                          buildTextField("City", _patientCity, "City"),

                          SizedBox(height: 10),

                          Row(
                            children: [
                              // Wrap the first child with Flexible to allow space adjustment
                              Flexible(
                                flex: 2, // Ensure equal space distribution
                                child: DropDownList(
                                    state,
                                    states,
                                    _patientState,
                                    "Select State",
                                    _stateFocusNode),
                              ),
                              SizedBox(
                                  width:
                                      10), // Add spacing between the two fields
                              Flexible(
                                flex:
                                    1, // Ensure the second child gets equal space
                                child: buidlNumberFeild(
                                    "Pin Code", _patientPincode, "Pin Code", 6),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          buildExpandableField(
                              "Comments", _patientComments, "Comments"),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              print("crearte");
                              if (await createAppointment() == true) {
                                // Get.toNamed(AppRoutes.HomeRoute);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppColors.primary),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // SizedBox(
                                  //   width: 40,
                                  // ),
                                  Container(
                                    height: 16,
                                    width: 10,
                                    child: SvgPicture.asset(
                                      "assets/images/ruppe_icon_white.svg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    controller.doctorDetails["appointmentPrice"]
                                            .toString() ??
                                        "250",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        height: 24 / 18),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Pay & Book Slot",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 16 / 16),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    height: 16,
                                    width: 16,
                                    child: SvgPicture.asset(
                                      "assets/images/arrow_forward_white.svg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 40,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
            selectedIndex:
                AppRoutes.routesIndex[AppRoutes.HospitalsRoute] as int));
  }

  Widget buidlNumberFeild(String hintText, TextEditingController controller,
      String type, int limit) {
    return SizedBox(
      height: 36,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$')),
          LengthLimitingTextInputFormatter(limit)
        ],
        validator: (value) {
          if (type == "Age") {
            if (value != null && value.isNotEmpty) {
              int? age =
                  int.tryParse(value); // Parse the string into an integer
              if (age == null) {
                return "Please enter a valid age.";
              } else if (age > 100) {
                return "Age should less than 100";
              }
            }
          }
          if (type == "Phone Number") {
            if (value == null || value.isEmpty) {
              return "Phone Number is required";
            }
          }
          if (type == "Pin Code") {
            if (value == null || value.isEmpty) {
              return "Pin Code is required";
            }
          }
          return null;
        },
        controller: controller,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                height: 20 / 12,
                fontSize: 12)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Color.fromRGBO(113, 125, 136, 1),
                  fontWeight: FontWeight.w400,
                  height: 20 / 12,
                  fontSize: 12)),
          isDense: true, // Reduces the overall height
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(width: 1.5, color: Color.fromRGBO(208, 218, 227, 1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(width: 1.5, color: Color.fromRGBO(208, 218, 227, 1)),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String hintText, TextEditingController controller, String type) {
    return SizedBox(
      height: 36,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$type is required";
          }
          return null;
        },
        controller: controller,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                height: 20 / 12,
                fontSize: 12)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Color.fromRGBO(113, 125, 136, 1),
                  fontWeight: FontWeight.w400,
                  height: 20 / 12,
                  fontSize: 12)),
          isDense: true, // Reduces the overall height
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(width: 1.5, color: Color.fromRGBO(208, 218, 227, 1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(width: 1.5, color: Color.fromRGBO(208, 218, 227, 1)),
          ),
        ),
      ),
    );
  }

  Widget buildExpandableField(
      String hintText, TextEditingController controller, String type) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 72, // Minimum height of the container
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Color.fromRGBO(208, 218, 227, 1),
        ),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (type == "Address") {
            if (value == null || value.isEmpty) {
              return "Address is required";
            }
          }
          return null;
        },
        controller: controller,
        minLines: 1, // Minimum number of lines (allows initial height)
        maxLines: null, // Expands dynamically based on content
        keyboardType: TextInputType.multiline, // Allows multi-line input
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            height: 20 / 12,
            fontSize: 12,
          ),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Color.fromRGBO(113, 125, 136, 1),
              fontWeight: FontWeight.w400,
              height: 20 / 12,
              fontSize: 12,
            ),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: InputBorder.none, // Removes all borders from the TextField
          focusedBorder: InputBorder.none, // No border on focus
          enabledBorder: InputBorder.none, // No border when enabled
          disabledBorder: InputBorder.none, // No border when disabled
          errorBorder: InputBorder.none, // No border on error
        ),
      ),
    );
  }
}
