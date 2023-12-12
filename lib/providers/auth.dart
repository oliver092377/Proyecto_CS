import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = '';
  static bool _confirmation = false;
  DateTime _expiryDate = DateTime.now();
  String _userId = '';

  bool get isAuth {
    return _token != '';
  }

  bool get isConfirmed {
    return _confirmation;
  }

  String get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != '') {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  void confirmacion(String mess) {
    //if
  }

  Future<List<String>> signup(String email, String password) async {
    List<String> arreglo;
    String respuesta = '';
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAu1GSAhSnfad7XaT_ZbsHxkO4mkF0uJX4';
    final response = await http.post(Uri.parse(url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    final responseData = json.decode(response.body);
    print(responseData);
    try {
      if (responseData['error'] != null) {
        var errorMessage = responseData['error']['message'];
        if (errorMessage.contains('EMAIL_EXISTS')) {
          respuesta = 'Este mail ya está en uso';
        } else if (errorMessage.toString().contains('INVALID_EMAIL')) {
          respuesta = 'Este no es un email válido';
        } else if (errorMessage.toString().contains('WEAK_PASSWORD')) {
          respuesta = 'La contraseña es muy debil';
        } else if (errorMessage.toString().contains('EMAIL_NOT_FOUND')) {
          respuesta = 'No se encontró usuario con este mail';
        } else if (errorMessage.toString().contains('INVALID_PASSWORD')) {
          respuesta = 'Contraseña inválida';
        } else if (errorMessage.toString().contains('MISSING_PASSWORD')) {
          respuesta = 'No ha ingresado la contraseña, inténtelo de nuevo';
        } else {
          respuesta = 'No se pudo autentificar, intente más tarde';
        }
        print(errorMessage.toString());
        arreglo = [respuesta, 'Ocurrió un error'];
        return arreglo;
      }
    } catch (error) {
      print(error);
    }
    if (responseData['idToken'] != null) {
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(
        responseData['expiresIn'],
      )));
      final url2 =
          'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyAu1GSAhSnfad7XaT_ZbsHxkO4mkF0uJX4';
      final response2 = await http.post(Uri.parse(url2),
          body: json.encode({
            'requestType': 'VERIFY_EMAIL',
            'idToken': _token,
          }));
      final responseData2 = json.decode(response2.body);
      print(responseData2);
      respuesta = 'Esperando confirmacion de email';
      return arreglo = [respuesta, 'Mensaje'];
    } else {
      final url3 =
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyAu1GSAhSnfad7XaT_ZbsHxkO4mkF0uJX4';
      final Map<String, dynamic> confirmationData = {
        'idToken': responseData['idToken'],
        'requestType': 'VERIFY_EMAIL',
      };
      final response3 = await http.post(
        Uri.parse(url3),
        body: json.encode(confirmationData),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData3 = json.decode(response3.body);
      if (responseData3['emailVerified'] == false) {
        respuesta = 'Esperando verificación de email';
      } else {
        respuesta = '';
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        });
        prefs.setString('userData', userData);
        prefs.get('key');
      }
    }

    return arreglo = [respuesta, 'Mensaje'];
  }

  Future<List<String>> login(String email, String password) async {
    // MEJORAR LOGINNNNNNNNN(PARA QUE NO DEJE EMTRAR AL MENOS QUE ESTES VERIFICADO)
    List<String> arreglo;
    String respuesta = '';
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAu1GSAhSnfad7XaT_ZbsHxkO4mkF0uJX4';
    final response = await http.post(Uri.parse(url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    final responseData = json.decode(response.body);
    try {
      if (responseData['error'] != null) {
        var errorMessage = responseData['error']['message'];
        if (errorMessage.contains('EMAIL_EXISTS')) {
          respuesta = 'Este mail ya está en uso';
        } else if (errorMessage.toString().contains('INVALID_EMAIL')) {
          respuesta = 'Este no es un email válido';
        } else if (errorMessage.toString().contains('WEAK_PASSWORD')) {
          respuesta = 'La contraseña es muy debil';
        } else if (errorMessage.toString().contains('EMAIL_NOT_FOUND')) {
          respuesta = 'No se encontró usuario con este mail';
        } else if (errorMessage.toString().contains('INVALID_PASSWORD')) {
          respuesta = 'Contraseña inválida';
        } else if (errorMessage.toString().contains('MISSING_PASSWORD')) {
          respuesta = 'No ha ingresado la contraseña, inténtelo de nuevo';
        } else {
          respuesta = 'No se pudo autentificar, intente más tarde';
        }
        print(errorMessage.toString());
        return arreglo = [respuesta, 'Ocurrió un error'];
      } else {
        final url3 =
            'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyAu1GSAhSnfad7XaT_ZbsHxkO4mkF0uJX4';
        final Map<String, dynamic> confirmationData = {
          'idToken': responseData['idToken'],
          'requestType': 'VERIFY_EMAIL',
        };
        final response3 = await http.post(
          Uri.parse(url3),
          body: json.encode(confirmationData),
          headers: {'Content-Type': 'application/json'},
        );
        final responseData3 = json.decode(response3.body);

        if (responseData3['emailVerified'] == false) {
          respuesta = 'El email NO está confirmado';
        } else {
          _token = responseData['idToken'];
          _userId = responseData['localId'];
          _expiryDate = DateTime.now().add(Duration(
              seconds: int.parse(
            responseData['expiresIn'],
          )));

          notifyListeners();
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode({
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String()
          });
          prefs.setString('userData', userData);
          prefs.get('key');
        }
      }
    } catch (error) {
      print(error);
    }
    return arreglo = [respuesta, 'Mensaje'];
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('Esto es falso');
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final Map<String, Object> userData =
        Map<String, Object>.from(extractedUserData);

    //var s = userData['expiryDate'];
    if (userData['expiryDate'] is String) {
      final expiryDate = DateTime.parse(userData['expiryDate'].toString());
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = userData['token'].toString();
      _userId = userData['userId'].toString();
      _expiryDate = expiryDate;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
