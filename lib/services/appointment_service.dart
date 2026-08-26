import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/appointment.dart';
import 'api_client.dart';

class AppointmentService {
  final GraphQLClient _graphQLClient = ApiClient().graphQLClient;
  final Dio _dio = ApiClient().dio;

  static const String _getAdminAppointmentsQuery = '''
    query GetAdminAppointments(\$status: String) {
      getAdminAppointments(status: \$status) {
        id
        userId
        doctorId
        status
        preferredDate
        formDetails
        prescriptionUrl
        createdAt
      }
    }
  ''';

  Future<List<Appointment>> getAppointments({String? status}) async {
    final QueryOptions options = QueryOptions(
      document: gql(_getAdminAppointmentsQuery),
      variables: status != null ? {'status': status} : {},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await _graphQLClient.query(options);

    if (result.hasException) {
      throw Exception(ApiClient().handleError(result.exception));
    }

    final List<dynamic>? data = result.data?['getAdminAppointments'];
    if (data == null) return [];

    return data.map((json) => Appointment.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final response = await _dio.post(
        '/api/appointments',
        data: {
          'user_id': appointment.userId,
          'doctor_id': appointment.doctorId,
          'preferred_date': appointment.preferredDate.toIso8601String().split('T')[0],
          if (appointment.formDetails != null) 'form_details': appointment.formDetails,
        },
      );
      
      return Appointment.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> updateAppointmentStatus(String id, String newStatus) async {
    try {
      await _dio.patch(
        '/api/admin/appointments/$id',
        data: {'status': newStatus},
      );
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _dio.delete('/api/admin/appointments/$id');
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<Appointment> uploadPrescription(String id, Uint8List fileBytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName.isEmpty ? 'prescription.pdf' : fileName),
      });

      final response = await _dio.post(
        '/api/admin/appointments/$id/upload-prescription',
        data: formData,
      );

      return Appointment.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }
}
