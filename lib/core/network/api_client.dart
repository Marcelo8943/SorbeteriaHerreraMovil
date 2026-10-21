import 'dart:convert';

import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client = http.Client();
  Future<dynamic> get(String path, {Map<String, String>? query}) async =>
      _send('GET', path, query: query);
  Future<dynamic> post(String path, {Object? body}) async =>
      _send('POST', path, null, body);
  Future<dynamic> put(String path, {Object? body}) async =>
      _send('PUT', path, body: body);
  Future<dynamic> delete(String path) async =>
      _send('DELETE', path, null, null);
  Future<dynamic> patch(String path, {Object? body}) async =>
      _send('PATCH', path, body: body);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;

    //base URL = http://localhost:5177/API
    //paht: /users
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final headers = {'Content-Type': 'application/json'};
    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }

    final request = http.Request(method, uri)..headers.addAll(headers);
    if (body != null) {
      request.body = jsonEncode(body);
    }

    final http.Response response;
    try {
      response = await _client
          .send(request)
          .timeout(ApiConstants.timeDuration)
          .then(http.Response.fromStream);
    } catch (e) {
      throw Exception('failed to send request: $e');
    }
    return response;
  }
}
