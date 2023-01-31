import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final params = {
      'key': 'AIzaSyDKt-4PSZIUe2LXMXTvjMT3Kq-DqG3xW-4',
    };
    final authUri =
        Uri.https('identitytoolkit.googleapis.com', '/v1/$urlSegment', params);
    try {
      final response = await http.post(authUri,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }
}
