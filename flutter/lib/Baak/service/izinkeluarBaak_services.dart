import 'dart:convert';
import 'package:itdel/Autentikasi/Login/login_services.dart';
import 'package:http/http.dart' as http;
import 'package:itdel/api_response.dart';
import 'package:itdel/Baak/model/izinkeluarBaak.dart'; // Sesuaikan dengan lokasi file model IzinKeluar.dart Anda
import 'package:itdel/global.dart';

class IzinKeluarBaakController {
  static Future<ApiResponse<String>> approveIzinKeluar(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'izin-keluar/$izinId/approve'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Keluar Telah Disetujui';
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
      print("Error in approveIzinKeluar: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<List<IzinKeluar>>> viewAllRequestsForBaak() async {
    ApiResponse<List<IzinKeluar>> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.get(
        Uri.parse(baseURL + 'izin-keluar/all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          Iterable data = json.decode(response.body)['RequestIzinKeluar'];
          List<IzinKeluar> izinKeluarList =
              data.map((json) => IzinKeluar.fromJson(json)).toList();
          apiResponse.data = izinKeluarList;
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
