import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:itdel/api_response.dart';
import 'package:itdel/Baak/model/izinbermalamBaak.dart';
import 'package:itdel/global.dart';
import 'package:itdel/Autentikasi/Login/login_services.dart';

class IzinBermalamBaakController {
  static Future<ApiResponse<String>> approveIzinBermalam(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'izin-bermalam/$izinId/approve'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Bermalam Telah Disetujui';
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in approveIzinBermalam: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<List<IzinBermalam>>>
      viewAllRequestsForBaak() async {
    ApiResponse<List<IzinBermalam>> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.get(
        Uri.parse(baseURL + 'izin-bermalam/all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          Iterable data = json.decode(response.body)['RequestIzinBermalam'];
          List<IzinBermalam> izinBermalamList =
              data.map((json) => IzinBermalam.fromJson(json)).toList();
          apiResponse.data = izinBermalamList;
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in viewAllRequestsForBaak: $e");
    }

    return apiResponse;
  }
}
