import 'dart:convert';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = 'f59807f364e102d7cd2816d61804efc0';

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
      username: username,
      password: password,
      requestToken: token,
    );
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<String> _makeToken() async {
    final url = _makeUri(
      '/authentication/token/new',
      <String, dynamic>{'api_key': _apiKey},
    );

    try {
      final response = await _dio.getUri(url);
      final json = response.data as Map<String, dynamic>;
      final token = json['request_token'] as String;
      return token;
    } catch (error) {
      throw Exception('Failed to obtain request token: $error');
    }
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final url = _makeUri(
      '/authentication/token/validate_with_login',
      <String, dynamic>{'api_key': _apiKey},
    );
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };

    try {
      final response = await _dio.postUri(url, data: jsonEncode(parameters));
      final json = response.data as Map<String, dynamic>;
      final token = json['request_token'] as String;
      return token;
    } catch (error) {
      throw Exception('Failed to validate user: $error');
    }
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    final url = _makeUri(
      '/authentication/session/new',
      <String, dynamic>{'api_key': _apiKey},
    );
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };

    try {
      final response = await _dio.postUri(url, data: jsonEncode(parameters));
      final json = response.data as Map<String, dynamic>;
      final sessionId = json['session_id'] as String;
      return sessionId;
    } catch (error) {
      throw Exception('Failed to create session: $error');
    }
  }
}