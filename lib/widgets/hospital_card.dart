import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_app/utils/colors.dart';
import '../models/hospital.dart';
import '../utils/app_constant.dart';

class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  bool forHomeScreen = false;
  HospitalCard(
      {super.key, required this.hospital, required this.forHomeScreen});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                forHomeScreen ? Color.fromRGBO(241, 244, 248, 1) : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: CachedNetworkImage(
                  height: 148,
                  width: double.infinity,
                  imageUrl: hospital.image != ""
                      ? "${AppConstant.ImageDomain}/${hospital.image}"
                      : "${AppConstant.ImageDomain}/fallback-Hospital.jpg",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: Colors.red),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${hospital.title}",
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  hospital.address,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    height: 30,
                    // width: 60,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: forHomeScreen
                          ? Colors.white
                          : AppColors.doctorScreenBackgroudColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          "assets/images/star_icon.svg",
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 3.0),
                        Text(
                          "${hospital.rating}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${hospital.doctorsCount}+ Doctors",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          top: 152,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: hospital.isAvailableToday
                  ? Color.fromRGBO(228, 255, 223, 1)
                  : Color.fromRGBO(255, 216, 216, 1),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(width: 2, color: Colors.white),
            ),
            child: Text(
              hospital.isAvailableToday == true ? "Open Today" : "Closed",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: hospital.isAvailableToday
                    ? Color.fromRGBO(27, 191, 0, 1)
                    : Color.fromRGBO(255, 0, 0, 1),
              ),
            ),
          ),
        )
      ],
    );
  }
}
