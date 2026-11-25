import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const sampleProjects = [
  {
    'id': '11111111-1111-1111-1111-111111111111',
    'title': 'MyPortfolio',
    'description': 'Website portofolio',
    'status': 'completed',
    'project_type': 'individual',
    'tech_stack': ['Django', 'Flutter'],
    'project_url': 'https://contoh.com',
    'project_image_url': '',
  },
];

MockClient fakeBackend({
  List<Object> projects = sampleProjects,
  int projectPostStatus = 201,
  List<http.Request>? log,
}) {
  return MockClient((request) async {
    log?.add(request);
    final path = request.url.path;
    if (path == '/api/v1/projects/' && request.method == 'GET') {
      return http.Response(jsonEncode(projects), 200);
    }
    if (path == '/api/v1/projects/' && request.method == 'POST') {
      if (projectPostStatus != 201) {
        return http.Response('{"detail":"x"}', projectPostStatus);
      }
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({...body, 'id': 'new-id', 'tech_stack': []}),
        201,
      );
    }
    if (path == '/api/v1/auth/token/') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      return body['password'] == 'benar'
          ? http.Response('{"token":"abc123"}', 200)
          : http.Response('{"non_field_errors":["x"]}', 400);
    }
    if (path == '/api/v1/auth/logout/') {
      return http.Response('', 204);
    }
    return http.Response('not found', 404);
  });
}

Widget buildApp({MockClient? client, String? token = 'token'}) {
  return MyApp(
    apiClient: ApiClient(client: client ?? fakeBackend()),
    initialToken: token,
  );
}
