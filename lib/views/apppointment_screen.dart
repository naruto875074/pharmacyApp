import 'package:flutter/material.dart';
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hospital_app/utils/colors.dart";
import 'package:hospital_app/utils/routes.dart';
import '../widgets/appoinment_card.dart';
import './bottom_navigation_bar.dart';
import "../controllers/appoinment_controller.dart";
import '../models/appoinment.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late AppoinmentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AppoinmentController(), tag: 'AppoinmentScreen');
  }

  @override
  void dispose() {
    Get.delete<AppoinmentController>(tag: 'AppoinmentScreen');
    super.dispose();
    print("delete");
  }

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
            Get.back();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Profile",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Obx(() {
              return Text(
                "You have ${controller.appointmentList.length} appointments",
                style: GoogleFonts.poppins(
                  color: const Color.fromRGBO(0, 0, 0, 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            })
          ],
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: AppRoutes.routesIndex[AppRoutes.profileRoute] as int,
      ),
      body: Container(
        color: AppColors.doctorScreenBackgroudColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: Colors.white,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Disable inner scrolling
                    itemCount: controller.appointmentList.length,
                    itemBuilder: (context, index) {
                      AppointmentData appointmentData =
                          controller.appointmentList[index];
                      return AppointmentCard(
                        appointmentData: appointmentData,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
