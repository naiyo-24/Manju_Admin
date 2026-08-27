import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  ApiClient._internal();

  // URLs
  static const String baseUrl = kReleaseMode 
      ? 'https://newappbackend.manjumedicalstores.com' 
      : 'http://localhost:8000';
  static const String graphqlEndpoint = '$baseUrl/graphql';
  
  // Clients
  late Dio _dio;
  late GraphQLClient _graphQLClient;
  
  String? _authToken;

  void initialize({String? token}) {
    _authToken = token;

    // 1. Initialize Dio (for REST/HTTP requests)
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      },
    ));
    // Add pretty logging interceptor for Dio
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    // 2. Initialize GraphQL Client
    final HttpLink httpLink = HttpLink(graphqlEndpoint);
    
    final AuthLink authLink = AuthLink(
      getToken: () async => _authToken != null ? 'Bearer $_authToken' : null,
    );

    final Link link = authLink.concat(httpLink);

    _graphQLClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(), // In-memory cache by default
    );
  }

  // Set auth token when user logs in
  void setToken(String token) {
    initialize(token: token);
  }
  
  void clearToken() {
    initialize(token: null);
  }

  // Accessors
  Dio get dio => _dio;
  GraphQLClient get graphQLClient => _graphQLClient;

  // Generic Error Handler Example
  String handleError(dynamic error) {
    if (error is DioException) {
      return error.response?.data?['message'] ?? error.message ?? 'Unknown network error';
    } else if (error is OperationException) {
      if (error.graphqlErrors.isNotEmpty) {
        return error.graphqlErrors.first.message;
      }
      return 'GraphQL operation failed';
    }
    return error.toString();
  }
}
