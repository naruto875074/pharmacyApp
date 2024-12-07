import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/appoinment.dart';
import '../models/payment.dart';
import '../utils/dio_client.dart';
import 'package:dio/dio.dart';
import '../utils/auth_helper.dart';
import '../utils/routes.dart';

class PaymentController extends GetxController {
  var paymentList = <PaymentData>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    isLoading.value = true;
    try {
      final token = AuthHelper.getToken() ?? "";
      Options options = Options(headers: {'Authorization': "Bearer $token"});
      final response =
          await DioClient.dio.get("/patient/transactions", options: options);

      if (response.statusCode == 200) {
        var data = response.data;
        var allTransactions = data?["data"] ?? [];

        paymentList.value = allTransactions
            .map((e) {
              return PaymentData.fromJson(e);
            })
            .toList()
            .cast<PaymentData>();
      }
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      if (e.response?.statusCode == 401) {
        // Unauthorized error
        Get.snackbar(
          '',
          'Your session has expired. Please login again.',
          duration: Duration(seconds: 1),
        );
        await Future.delayed(Duration(seconds: 1));
        Get.offAllNamed(AppRoutes.loginRoute);

        // Optionally, log out the user or navigate to login screen
        // AuthHelper.logout(); // Add your logout logic here
      } else {
        Get.snackbar(
          'Error',
          e.response?.data?['message'] ?? 'Failed to fetch payments',
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Handle other exceptions
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
