import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hospital_app/utils/colors.dart";
import 'package:hospital_app/utils/routes.dart';
import '../widgets/appoinment_card.dart';
import './bottom_navigation_bar.dart';
import '../controllers/payment_controller.dart';
import '../models/payment.dart';
import '../widgets/payment_card.dart';
import './bottom_navigation_bar.dart';
import '../utils/routes.dart';

class TranscationScreen extends StatefulWidget {
  final String firstName;
  final String doctorName;
  final String hospitalName;
  final String dateOfBooking;
  final String opdNo;
  final String amount;
  const TranscationScreen(
      {super.key,
      required this.firstName,
      required this.doctorName,
      required this.hospitalName,
      required this.dateOfBooking,
      required this.opdNo,
      required this.amount});

  @override
  State<TranscationScreen> createState() => _TranscationScreenState();
}

class _TranscationScreenState extends State<TranscationScreen> {
  final Color lightText = Color.fromRGBO(27, 43, 58, 1);
  final Color darkText = Color.fromRGBO(0, 0, 0, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.black),
            onTap: () {
              // Get.back();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Appointment Booked",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "ID#52468",
                style: GoogleFonts.poppins(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )
              // Obx(() {
              //   return Text(
              //     "ID#52468",
              //     style: GoogleFonts.poppins(
              //       color: Color.fromRGBO(0, 0, 0, 0.6),
              //       fontSize: 14,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   );
              // })
            ],
          ),
          centerTitle: false,
        ),
        body: Container(
          color: AppColors.doctorScreenBackgroudColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  height: 306,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/transaction_icon.svg"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Patient",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: lightText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "jai shankar",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Doctor",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: lightText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Dr. Deepak pal",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hospital",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: lightText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Jeevan rakshak hospital",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Date & Time",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: lightText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "12.30 PM,Tue Aug 2023",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "OPD No.",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: lightText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "45745",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Amount",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: lightText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "250/-",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
            selectedIndex:
                AppRoutes.routesIndex[AppRoutes.HospitalsRoute] as int));
  }
}
