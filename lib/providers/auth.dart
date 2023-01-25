import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  Future<void> signup(String email, String password) async {
    const params = {
      'key': 'AIzaSyDKt-4PSZIUe2LXMXTvjMT3Kq-DqG3xW-4',
    };

    final authUri = Uri.https(
        'identitytoolkit.googleapis.com', '/v1/accounts:signUp', params);

    final response = await http.post(authUri,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    print(json.decode(response.body));
  }
}
