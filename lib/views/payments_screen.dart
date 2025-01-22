import 'package:flutter/material.dart';
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hospital_app/utils/colors.dart";
import 'package:hospital_app/utils/routes.dart';
import '../widgets/appoinment_card.dart';
import './bottom_navigation_bar.dart';
import '../controllers/payment_controller.dart';
import '../models/payment.dart';
import '../widgets/payment_card.dart';
import '../utils/routes.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late PaymentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PaymentController(), tag: 'PaymentScreen');
  }

  @override
  void dispose() {
    Get.delete<PaymentController>(tag: 'PaymentScreen');
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
              Get.offNamed(AppRoutes.profileRoute);
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
              SizedBox(height: 4),
              Obx(() {
                return Text(
                  "You have ${controller.paymentList.length} payments",
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
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
        body: Obx(
          () => Container(
            color: controller.isLoading.value
                ? Colors.white
                : AppColors.doctorScreenBackgroudColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Obx(() {
                    if (controller.isLoading.value) {
                      print("Loading Payments...");
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      color: Colors.white,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Disable inner scrolling
                        itemCount: controller.paymentList.length,
                        itemBuilder: (context, index) {
                          PaymentData paymentData =
                              controller.paymentList[index];
                          return PaymentCard(paymentData: paymentData);
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
        ));
  }
}
