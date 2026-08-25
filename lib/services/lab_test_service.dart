import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/lab_test.dart';
import 'api_client.dart';

class LabTestService {
  final GraphQLClient _graphQLClient = ApiClient().graphQLClient;
  final Dio _dio = ApiClient().dio;

  // GraphQL Query
  static const String _getLabCatalogQuery = '''
    query GetLabCatalog {
      getLabCatalog {
        id
        type
        title
        price
        turnaround_time
        includes
      }
    }
  ''';

  Future<List<LabTest>> getLabTests() async {
    final QueryOptions options = QueryOptions(
      document: gql(_getLabCatalogQuery),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await _graphQLClient.query(options);

    if (result.hasException) {
      throw Exception(ApiClient().handleError(result.exception));
    }

    final List<dynamic>? catalogData = result.data?['getLabCatalog'];
    if (catalogData == null) return [];

    return catalogData.map((json) => LabTest.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<LabTest> createLabTest(LabTest test) async {
    try {
      final response = await _dio.post(
        '/api/admin/lab-catalog/',
        data: test.toJson(),
      );
      
      return LabTest.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> updateLabTest(LabTest test) async {
    try {
      await _dio.put(
        '/api/admin/lab-catalog/${test.id}',
        data: test.toJson(),
      );
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> deleteLabTest(String id) async {
    try {
      await _dio.delete('/api/admin/lab-catalog/$id');
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }
}
