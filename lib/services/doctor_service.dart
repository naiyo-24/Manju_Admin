import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/doctor.dart';
import 'api_client.dart';

class DoctorService {
  final GraphQLClient _graphQLClient = ApiClient().graphQLClient;
  final Dio _dio = ApiClient().dio;

  // GraphQL Queries
  static const String _getDoctorsQuery = '''
    query GetDoctors {
      getDoctors {
        id
        name
        specialtyKey
        experience
        fee
        about
        imageUrl
      }
    }
  ''';

  Future<List<Doctor>> getDoctors() async {
    final QueryOptions options = QueryOptions(
      document: gql(_getDoctorsQuery),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await _graphQLClient.query(options);

    if (result.hasException) {
      throw Exception(ApiClient().handleError(result.exception));
    }

    final List<dynamic>? doctorsData = result.data?['getDoctors'];
    if (doctorsData == null) return [];

    return doctorsData.map((json) => Doctor.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Doctor> createDoctor(Doctor doctor) async {
    try {
      final response = await _dio.post(
        '/api/admin/doctors/',
        data: doctor.toJson(),
      );
      
      return Doctor.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      await _dio.put(
        '/api/admin/doctors/${doctor.id}',
        data: doctor.toJson(),
      );
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      await _dio.delete('/api/admin/doctors/$id');
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<Doctor> uploadDoctorImage(String id, Uint8List imageBytes) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: 'profile.jpg', // A default filename is required by most backends
        ),
      });

      final response = await _dio.post(
        '/api/admin/doctors/$id/upload-image',
        data: formData,
      );

      return Doctor.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }
}


