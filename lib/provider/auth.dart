import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_models/login_body.dart';
import '../models/user_models/login_response.dart';
import '../provider/urls.dart';

class Auth with ChangeNotifier {
  String _token = '';
  String _credentialAccessToken = '';
  late bool _isLoggedIn;

  bool get isAuth {
    getToken();
    return _token != '';
  }

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
  }

  late LoginBody loginBody;

  String get token => _token;

  String get credentialAccessToken => _credentialAccessToken;
  Map<String, String> headers = {};

  Future<bool> getCredentialToken() async {
    final url = Urls.rootUrl + Urls.loginEndPoint;
    print(url);

    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'grant_type': 'client_credentials',
            'client_id': '3',
            'client_secret': dotenv.env['client_secret'],
          }));

      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData != 'false') {
        try {
          LoginResponse loginResponse = LoginResponse.fromJson(responseData);
          _credentialAccessToken = loginResponse.access_token;
          final prefs = await SharedPreferences.getInstance();

          prefs.setString('credential_access_token', _credentialAccessToken);
          prefs.setString('expires_in', loginResponse.expires_in.toString());
          prefs.setString('refresh_token', loginResponse.refresh_token);
          print(_credentialAccessToken);
          prefs.setString('isLogin', 'true');
        } catch (error) {
          _credentialAccessToken = '';
        }
        return true;
      } else {
        final prefs = await SharedPreferences.getInstance();

        _credentialAccessToken = '';
        prefs.setString('credential_access_token', _credentialAccessToken);
        print(_credentialAccessToken);
        print('noooo _credential_access_token');
        prefs.setString('isLogin', 'true');
        return false;
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<bool> authenticate(String verificationCode, String phoneNumber) async {
    final url = Urls.rootUrl + Urls.loginEndPoint;
    print(url);

    try {
      print(phoneNumber);
      print(verificationCode);

      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'grant_type': 'password',
            'client_id': '2',
            'client_secret': dotenv.env['client_secret2'],
            'username': phoneNumber,
            'password': verificationCode,
          }));

      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData != 'false') {
        try {
          LoginResponse loginResponse = LoginResponse.fromJson(responseData);
          _token = loginResponse.access_token;
          final prefs = await SharedPreferences.getInstance();

          prefs.setString('token', _token);
          prefs.setString('expires_in', loginResponse.expires_in.toString());
          prefs.setString('refresh_token', loginResponse.refresh_token);
          print(_token);
          prefs.setString('isLogin', 'true');
          _isLoggedIn = true;
        } catch (error) {
          _isLoggedIn = false;

          _token = '';
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        _isLoggedIn = false;

        _token = '';
        prefs.setString('token', _token);
        print(_token);
        print('noooo token');
        prefs.setString('isLogin', 'true');
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _isLoggedIn;
  }

  Future<bool> sendSMS(String phoneNumber) async {
    print('sendSMS');

    final url = Urls.rootUrl + Urls.sendSMSEndPoint + '?mobile=$phoneNumber';
    print(url);
    print(_credentialAccessToken);

    try {
      if (_credentialAccessToken.isEmpty) {
        await getCredentialToken();
        print(_credentialAccessToken);
      }
      print(_credentialAccessToken);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_credentialAccessToken',
          'Accept': 'application/json'
        },
      );
      return true;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token') != null ? prefs.getString('token')! : '';

    notifyListeners();
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = '';
    print('toookeeen');
    print(prefs.getString('token'));
    notifyListeners();
  }
}
