import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_app/utils/colors.dart';
import '../models/doctor.dart';
import '../utils/app_constant.dart';

class HomeScreenDoctorCard extends StatelessWidget {
  final Doctor doctor;
  const HomeScreenDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColors.doctorScreenBackgroudColor,
      ),
      child: Row(
        children: [
          // Doctor's Image
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: doctor.image != ""
                    ? "${AppConstant.ImageDomain}/${doctor.image}"
                    : "${AppConstant.ImageDomain}/doctor-fallback.jpg",
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          // Doctor's Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${doctor.honorific} ${doctor.name}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 24 / 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "${doctor.department} • ${doctor.experienceCount}+ Years",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    // Rating
                    Flexible(
                      flex: 7,
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              "assets/images/star_icon.svg",
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "${doctor.rating}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Flexible(flex: 1, child: SizedBox(width: 8.0)),
                    // Consultation Fee
                    Flexible(
                      flex: 7,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        width: 61,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/ruppe_icon.svg"),
                            Text(
                              "${doctor.appointmentPrice}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(0, 0, 0, 0.8),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: 8,
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: Container(
                        height: 25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: doctor.isAvailableToday
                              ? Color.fromRGBO(228, 255, 223, 1)
                              : Color.fromRGBO(255, 216, 216, 1),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Text(
                          doctor.isAvailableToday
                              ? "Available Today"
                              : "Not Available Today",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: doctor.isAvailableToday
                                ? Color.fromRGBO(27, 191, 0, 1)
                                : Color.fromRGBO(255, 0, 0, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 
 
//  Positioned(
//             top: -10,
//             right: 28,
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(228, 255, 223, 1),
//                 borderRadius: BorderRadius.circular(14.0),
//                 border: Border.all(width: 2, color: Colors.white),
//               ),
//               child: Text(
//                 "Available Today",
//                 style: GoogleFonts.poppins(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromRGBO(27, 191, 0, 1),
//                 ),
//               ),
//             ),
//           ),