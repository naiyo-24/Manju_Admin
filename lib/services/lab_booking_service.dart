import 'package:dio/dio.dart';
import 'dart:typed_data';
import '../models/lab_booking.dart';
import 'api_client.dart';

class LabBookingService {
  final Dio _dio = ApiClient().dio;

  Future<List<LabBooking>> getLabBookings({String? status}) async {
    const String query = '''
      query GetAdminLabBookings(\$status: String) {
        getAdminLabBookings(status: \$status) {
          id
          userId
          paymentMethod
          bookedItems
          status
          totalAmount
          preferredDate
          formDetails
          reportUrl
          createdAt
        }
      }
    ''';

    try {
      final response = await _dio.post(
        '/graphql',
        data: {
          'query': query,
          if (status != null) 'variables': {'status': status},
        },
      );

      if (response.data['errors'] != null) {
        throw Exception(response.data['errors'][0]['message']);
      }

      final data = response.data['data']['getAdminLabBookings'] as List;
      return data.map((json) => LabBooking.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<LabBooking> createLabBooking(LabBooking booking) async {
    try {
      final response = await _dio.post(
        '/api/lab-bookings',
        data: {
          'user_id': booking.userId,
          'item_ids': booking.bookedItems.map((i) => i['id']).toList(),
          'preferred_date': booking.preferredDate.toIso8601String().split('T')[0],
          if (booking.formDetails != null) 'form_details': booking.formDetails,
          'payment_method': booking.paymentMethod,
          'status': booking.status,
        },
      );
      
      return LabBooking.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> updateLabBookingStatus(String id, String newStatus) async {
    try {
      await _dio.patch(
        '/api/admin/lab-bookings/$id',
        data: {
          'status': newStatus,
        },
      );
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> cancelLabBooking(String id) async {
    try {
      await _dio.patch(
        '/api/lab-bookings/$id/cancel',
      );
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }
  
  Future<String> uploadLabReport(String id, Uint8List fileBytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await _dio.post(
        '/api/admin/lab-bookings/$id/upload-report',
        data: formData,
      );

      return response.data['report_url'] as String;
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<String> createGuestUser(String name, String phone) async {
    try {
      final response = await _dio.post(
        '/api/users/create',
        data: {
          'role': 'USER',
          'name': name.isEmpty ? 'Walk-in Patient' : name,
          'phone': phone,
        },
      );
      return response.data['id'] as String;
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }
}
