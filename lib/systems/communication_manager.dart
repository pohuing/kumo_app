import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kumo_app/models/path_point.dart';
import 'package:kumo_app/models/populated_permission.dart';

import '../models/explore_result.dart';
import '../models/permission.dart';
import '../models/role.dart';

class CommunicationManager {
  static final CommunicationManager _instance = CommunicationManager();

  static CommunicationManager get instance => _instance;
  Client client;
  String? token;

  String host = kIsWeb ? 'localhost:5001' : 'localhost:5001';

  CommunicationManager() : client = Client();

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token!}',
      };

  Future<bool> addPoint(String path, bool isRoot) async {
    final response = await client.post(
      Uri.https(host, '/api/PathPoint'),
      body: jsonEncode({
        'path': path,
        'isRoot': isRoot,
      }),
      headers: headers,
    );

    log(
      '${response.reasonPhrase ?? response.statusCode.toString()}: ${response.body}',
      name: '$runtimeType.addPoint',
    );
    return response.statusCode < 300 && response.statusCode >= 200;
  }

  Future<bool> deletePathPoint(PathPoint pathPoint) async {
    final response = await client.delete(
      Uri.https(host, '/api/PathPoint/${pathPoint.id}'),
      headers: headers,
    );

    return response.statusCode == 200;
  }

  Future<List<ExploreResult>> explore(String path) async {
    final response = await client.get(
      Uri.https(host, 'api/Explore', {'path': path}),
      headers: headers,
    );
    if (response.statusCode != 200) {
      return [];
    }
    // log(response.body, name:runtimeType.toString());
    final jsonDecoded = jsonDecode(response.body);
    return List.from(jsonDecoded['payload'])
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => ExploreResult.fromJSON(e))
        .toList();
  }

  Future<List<PathPoint>> getPathPoints() async {
    final response = await client.get(
      Uri.https(host, '/api/PathPoint'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      log('Got non 200: $response');
      return [];
    }

    final jsonDecoded = jsonDecode(response.body);

    return List.from(jsonDecoded['payload'])
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => PathPoint.fromJSON(e))
        .toList();
  }

  Future<bool> signIn(String email, String password) async {
    final response = await client.post(
      Uri.https(host, 'api/Authenticate/login'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    log(
      response.reasonPhrase ?? response.statusCode.toString(),
      name: runtimeType.toString(),
    );
    if (response.statusCode != 200) return false;

    final json =
        Map<String, dynamic>.from(jsonDecode(response.body)['payload']);
    final token = json['token'];
    if (token == null) {
      return false;
    }
    this.token = token;
    return true;
  }

  Future<bool> signUp(String email, String password) async {
    final response = await client.post(
      Uri.https(host, 'api/Authenticate/register'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    log(
      response.reasonPhrase ?? response.statusCode.toString(),
      name: runtimeType.toString(),
    );
    if (response.statusCode != 200) return false;

    return true;
  }

  Future<bool> updatePathPoint(PathPoint pathPoint) async {
    final response = await client.put(
      Uri.https(host, '/api/PathPoint'),
      body: jsonEncode({
        'id': pathPoint.id,
        'path': pathPoint.path,
        'isRoot': pathPoint.isRoot,
      }),
      headers: headers,
    );
    log(
      '${response.reasonPhrase ?? response.statusCode.toString()}: ${response.body}',
      name: '$runtimeType.updatePathPoint',
    );
    return response.statusCode == 200;
  }

  Future<List<Permission>> getPermissions() async {
    final response = await client.get(
      Uri.https(host, '/api/Permission'),
      headers: headers,
    );
    log(
      '${response.reasonPhrase ?? response.statusCode.toString()}: ${response.body}',
      name: '$runtimeType.getPermissions',
    );
    if (response.statusCode != 200) {
      return [];
    }

    final jsonDecoded = jsonDecode(response.body);

    final json = List.from(jsonDecoded['payload'])
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => Permission.fromJson(e))
        .whereType<Permission>()
        .toList();

    return json;
  }

  Future<List<Role>> getRoles() async {
    final response = await client.get(
      Uri.https(host, '/api/Role'),
      headers: headers,
    );
    log(
      '${response.reasonPhrase ?? response.statusCode.toString()}: ${response.body}',
      name: '$runtimeType.getPermissions',
    );
    if (response.statusCode != 200) {
      return [];
    }

    final jsonDecoded = jsonDecode(response.body);

    final json = List.from(jsonDecoded['payload'])
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => Role.fromJson(e))
        .whereType<Role>()
        .toList();

    return json;
  }

  Future<List<PopulatedPermission>> getPopulatedPermissions() async {
    late List<Permission> perms;
    late List<Role> roles;
    late List<PathPoint> points;
    await Future.wait([
      () async {
        perms = await CommunicationManager.instance.getPermissions();
      }(),
      () async {
        roles = await CommunicationManager.instance.getRoles();
      }(),
      () async {
        points = await CommunicationManager.instance.getPathPoints();
      }(),
    ]);

    return perms
        .map(
          (e) => PopulatedPermission(
            e,
            roles.firstWhere((role) => role.id == e.roleId),
            points.firstWhere((point) => point.id == e.pathPointId),
          ),
        )
        .toList();
  }
}
