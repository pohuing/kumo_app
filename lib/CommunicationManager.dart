import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

class CommunicationManager {
  static CommunicationManager _instance = CommunicationManager();
  Client client;
  String? token;

  static CommunicationManager get instance => _instance;

  Future<bool> signIn(String email, String password) async {
    final response = await client.post(
      Uri.https('localhost:5001', 'api/Authenticate/login'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    log(response.reasonPhrase ?? response.statusCode.toString(), name: runtimeType.toString());
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
    final response = await client.post(
        Uri.https('localhost:5001', 'api/Authenticate/register'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json'
        }
    );

    log(response.reasonPhrase ?? response.statusCode.toString(), name: runtimeType.toString());
    if (response.statusCode != 200) return false;

    return true;
  }
}
