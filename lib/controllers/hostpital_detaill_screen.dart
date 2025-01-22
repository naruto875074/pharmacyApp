import 'dart:convert';

import 'package:get/get.dart';
import 'package:hospital_app/utils/helper_class.dart';
import '../utils/dio_client.dart';
import '../models/doctor.dart';
import '../utils/auth_helper.dart';
import 'package:dio/dio.dart';

class HospitalDetailsController extends GetxController {
  var hospitalDetails = <String, dynamic>{}.obs;
  var doctorList = <Doctor>[].obs;
  var reviews = [].obs;
  var doctorReviews = [].obs;
  var doctorDetails = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var isDoctorListLoading = false.obs;
  var isDoctorDetailsLoading = false.obs;
  var isSlotsLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> fetchHospitalDetails(slug) async {
    try {
      isLoading.value = true;
      final response = await DioClient.dio.get("/patient/hospitals/$slug");
      if (response.statusCode == 201) {
        final data = response.data;
        hospitalDetails.value = data["data"];
      }
    } catch (error) {
      print(error);
      Get.snackbar('', 'Failed to get hospital details.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDoctorsList(slug) async {
    try {
      final response =
          await DioClient.dio.get("/patient/hospitals/$slug/doctors");
      if (response.statusCode == 200) {
        final data = response.data;
        var listOfDoctors = data?["data"]?["data"] ?? [];
        doctorList.value =
            List<Doctor>.from(listOfDoctors.map((e) => Doctor.fromJson(e)));
      }
    } catch (error) {
      print(error);
      Get.snackbar('', 'Failed to get Doctors list.');
    }
  }

  Future<void> fetchHospitalReviews(slug) async {
    try {
      final response =
          await DioClient.dio.get("/patient/hospitals/$slug/review");
      if (response.statusCode == 201) {
        final data = response.data;
        reviews.value = data["data"];
      }
    } catch (error) {
      print(error);
      Get.snackbar('', 'Failed to get hospital details.');
    }
  }

  Future<void> fetchParticularDoctorDetails(slug) async {
    try {
      isLoading.value = true;
      final response = await DioClient.dio.get("/patient/doctors/$slug");
      if (response.statusCode == 200) {
        final data = response.data;
        doctorDetails.value = data["data"];
      }
    } catch (error) {
      print(error);
      Get.snackbar('', 'Failed to get hospital details.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDoctorReviews(slug) async {
    try {
      isDoctorListLoading.value = true;
      final response = await DioClient.dio.get("/patient/doctors/$slug/review");
      if (response.statusCode == 201) {
        final data = response.data;
        doctorReviews.value = data["data"];
      }
    } catch (error) {
      print(error);
      Get.snackbar('', 'Failed to get hospital details.');
    } finally {
      isDoctorListLoading.value = false;
    }
  }

  Future<ReturnObj> fetchSlotsOfDoctor(date, slug) async {
    try {
      isSlotsLoading.value = true;
      final response = await DioClient.dio.post("/patient/appointments/slots",
          data: {"date": date, "doctor": slug});
      if (response.statusCode == 200) {
        final data = response.data;
        var list = data["data"];
        return ReturnObj(
            status: true, message: "slots fetched successfully", data: list);
      }
      return ReturnObj(
        status: false,
        message: "slots fetched failed",
      );
    } catch (error) {
      print(error);
      return ReturnObj(
        status: false,
        message: "slots fetched failed",
      );
    } finally {
      isSlotsLoading.value = false;
    }
  }

  Future<String> createAppointment(Map<String, dynamic> payload) async {
    try {
      var token = AuthHelper.getToken() ?? "";
      var options = Options(headers: {'Authorization': "Bearer ${token}"});

      var response = await DioClient.dio.post("/patient/appointments/create",
          data: json.encode(payload), options: options);

      if (response.statusCode == 201) {
        var data = response.data;
        String access_key = data?["data"]?["accessKey"];

        return access_key;
      }

      return "";
    } catch (error) {
      print(error);
      return "";
    }
  }
}
