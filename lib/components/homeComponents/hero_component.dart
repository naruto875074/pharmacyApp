import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/helper_class.dart';
import '../../controllers/home_controller.dart';
import '../../views/home_screen_search_modal.dart';

class HeroComponent extends StatefulWidget {
  HeroComponent({Key? key}) : super(key: key);
  @override
  State<HeroComponent> createState() => HeroComponentState();
}

class HeroComponentState extends State<HeroComponent> {
  late HomeController controller = HomeController();
  bool _isDropdownVisible = false;
  List<Map<String, String>> locationList = [];
  bool get isDropdownVisible => _isDropdownVisible;
  void toggleDropdownVisibility() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  void _openSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Dismiss when tapped outside
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent background
          insetPadding: EdgeInsets.zero, // Removes default padding
          child: HomeScreenSearchModal(
            controller: controller,
          ),
        );
      },
    );
  }

  @override
  initState() {
    controller = Get.find<HomeController>();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (_isDropdownVisible) {
          setState(() {
            _isDropdownVisible = false;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            // color: Color(0xFF0566D3), // Background color of the container
            gradient: LinearGradient(
              colors: [
                AppColors.primaryLight, // Top right ellipse color
                AppColors.primary, // Bottom solid background color
              ],
              stops: [
                0.10,
                1.0
              ], // Spread the first color to 25%, then transition to the second color
              begin: Alignment.topRight, // Start from the top right
              end: Alignment
                  .bottomCenter, // End the gradient at the bottom center
            ),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36))),
        height: 410.5,
        padding: EdgeInsets.only(top: 60, left: 28, right: 28),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 28,
                          width: 24,
                          child: SvgPicture.asset(
                            'assets/images/location.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(onTap: () {
                              setState(() {
                                _isDropdownVisible = !_isDropdownVisible;
                              });
                            }, child: Obx(() {
                              return Row(
                                children: [
                                  Text(
                                    controller.locations[controller
                                                .selectedLocation
                                                .value]?["title"] !=
                                            ""
                                        ? StringFunctions.capitalizeFirstLetter(
                                            controller.locations[controller
                                                .selectedLocation
                                                .value]?["title"])
                                        : "Not selected ",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white),
                                ],
                              );
                            })),
                            Text(
                              "Location",
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      TextStyle(color: AppColors.subtitle)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(5), // 5px padding
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.circular(8), // Radius of 8
                        ),
                        height: 50,
                        width: 50,
                        child: Container(
                          child: Image.asset(
                            'assets/images/doctor_placeholder.jpg',

                            fit: BoxFit
                                .cover, // Ensures the image covers the container
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(height: 44),
              Text(
                "Welcome Back",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                )),
              ),
              SizedBox(height: 10),
              Text(
                "Let’s find\nyour best doctor!",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                )),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.searchBarBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                // height: 58.5,
                child: TextField(
                  onTap: () => _openSearchDialog(context),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: AppColors.subtitle),
                    hintText: 'Search doctors, hospitals & services...',
                    hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: AppColors.subtitle,
                    )),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          if (_isDropdownVisible)
            Obx(() {
              return Positioned(
                top:
                    60, // Adjust this to align with the text (fine-tune as needed)
                left: 0, // Align with the start of the location text
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        200, // Full width minus padding
                    constraints:
                        BoxConstraints(maxHeight: 200), // Limit the height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black26,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: controller.locationList.map((location) {
                          return ListTile(
                            title: Text(
                              StringFunctions.capitalizeFirstLetter(
                                      location["city"]) ??
                                  "",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _isDropdownVisible = false; // Hide dropdown
                                controller.selectedLocation.value =
                                    location["qpId"];
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            })
        ]),
      ),
    );
  }
}
