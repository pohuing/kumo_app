import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import 'models/explore_result.dart';

class CommunicationManager {
  static CommunicationManager _instance = CommunicationManager();
  Client client;
  String? token;
  String host = 'localhost:5001';

  static CommunicationManager get instance => _instance;

  Future<bool> signIn(String email, String password) async {
    final response =
        await client.post(Uri.https(host, 'api/Authenticate/login'),
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
            headers: {'Content-Type': 'application/json'});

    log(response.reasonPhrase ?? response.statusCode.toString(),
        name: runtimeType.toString());
    if (response.statusCode != 200) return false;

    final json = Map<String, String>.from(jsonDecode(response.body));
    final token = json['token'];
    if (token == null) {
      return false;
    }
    this.token = token;
    return true;
  }

  CommunicationManager() : client = Client() {}

  Future<bool> signUp(String email, String password) async {
    final response =
        await client.post(Uri.https(host, 'api/Authenticate/register'),
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
            headers: {'Content-Type': 'application/json'});

    log(response.reasonPhrase ?? response.statusCode.toString(),
        name: runtimeType.toString());
    if (response.statusCode != 200) return false;

    return true;
  }

  Future<List<ExploreResult>> explore(String path) async {
    final response = await client.get(
      Uri.https(host, 'api/Explore', {'path': path}),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token!},
    );
    if(response.statusCode != 200)
      return [];
    // log(response.body, name:runtimeType.toString());
    var jsonDecoded = jsonDecode(response.body);// as List<Map<String, dynamic>>;
    return List.from(jsonDecoded).map((e) => Map<String,dynamic>.from(e)).map((e) => ExploreResult.fromJSON(e)).toList();

  }
}
