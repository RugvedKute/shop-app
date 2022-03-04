import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<Void> signUp(
    String email,
    String password,
  ) async {
    try {
      const params = {'key': 'AIzaSyDE5wr_ix_inaO7Z4P0cy32I286TuxLAdw'};
      final url = Uri.https(
          'identitytoolkit.googleapis.com', '/v1/accounts:signUp', params);
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Void> login(String email, String password) async {
    try {
      const params = {'key': 'AIzaSyDE5wr_ix_inaO7Z4P0cy32I286TuxLAdw'};

      final url = Uri.https('identitytoolkit.googleapis.com',
          '/v1/accounts:signInWithPassword', params);
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autologout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final userExtractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    var _expiryDate = DateTime.parse(userExtractedData['expiryDate']);
    if (_expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userExtractedData['token'];
    _userId = userExtractedData['userId'];
    _expiryDate = _expiryDate;
    notifyListeners();
    autologout();
    return true;
  }

  void autologout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final _expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: _expiryTime), logout);
  }
}
