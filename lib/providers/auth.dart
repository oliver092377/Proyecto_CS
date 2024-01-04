import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = '';

  DateTime _expiryDate = DateTime.now();
  String _userId = '';
  String _correo = '';
  String _photo = '';
  String _description = '';

  bool get isAuth {
    return _token != '';
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

  String get photo {
    return _photo;
  }

  String get description {
    return _description;
  }

  String get correo {
    return _correo;
  }

  Future<String> getPhotoUrl() async {
    String respuesta = "";
    var url =
        'https://prueba-164f3-default-rtdb.firebaseio.com/userData/$userId/.json?auth=$token';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      //print("respuesta: " + respuesta);
      print(response);
      if (response.statusCode == 200) {
        try {
          if (json.decode(response.body) != null) {
            respuesta = response.body;
            print("respuesta: " + respuesta);
          }
          notifyListeners();
        } catch (e) {}
      }
      return respuesta;
    } catch (error) {
      throw (error);
    }
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
      _correo = email;
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
          'correo': _correo,
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        });
        prefs.setString('userData', userData);
        prefs.get('key');
        var url =
            'https://prueba-164f3-default-rtdb.firebaseio.com/Photo/$userId/.json?auth=$token';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          if (json.decode(response.body) != null) {
            String rpta = response.body;
            String stringWithoutQuotes = rpta.replaceAll('"', '');

            print("stringWithoutQuotes: " +
                stringWithoutQuotes); // Salida: Hello, World!
            _photo = stringWithoutQuotes;
          }
          notifyListeners();
        }
        var url2 =
            'https://prueba-164f3-default-rtdb.firebaseio.com/Description/$userId/.json?auth=$token';
        final response2 = await http.get(Uri.parse(url2));
        if (response.statusCode == 200) {
          if (json.decode(response2.body) != null) {
            _description = response2.body;
          }
          notifyListeners();
        }
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
          _correo = email;
          _token = responseData['idToken'];
          _userId = responseData['localId'];
          _expiryDate = DateTime.now().add(Duration(
              seconds: int.parse(
            responseData['expiresIn'],
          )));

          notifyListeners();
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode({
            'correo': _correo,
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String()
          });
          prefs.setString('userData', userData);
          prefs.get('key');
          var url =
              'https://prueba-164f3-default-rtdb.firebaseio.com/Photo/$userId/.json?auth=$token';
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            if (json.decode(response.body) != null) {
              String rpta = response.body;
              String stringWithoutQuotes = rpta.replaceAll('"', '');

              print("stringWithoutQuotes: " +
                  stringWithoutQuotes); // Salida: Hello, World!
              _photo = stringWithoutQuotes;
            }
            notifyListeners();
          }
          var url2 =
              'https://prueba-164f3-default-rtdb.firebaseio.com/Description/$userId/.json?auth=$token';
          final response2 = await http.get(Uri.parse(url2));
          if (response.statusCode == 200) {
            if (json.decode(response2.body) != null) {
              _description = response2.body;
            }
            notifyListeners();
          }
        }
      }
    } catch (error) {
      print(error);
    }
    return arreglo = [respuesta, 'Mensaje'];
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs);
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
      _correo = userData['correo'].toString();
      _userId = userData['userId'].toString();
      _expiryDate = expiryDate;
      print(userData);
      print("userData['correo'].toString(): " + userData['correo'].toString());
      var url =
          'https://prueba-164f3-default-rtdb.firebaseio.com/Photo/$userId/.json?auth=$token';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (json.decode(response.body) != null) {
          String rpta = response.body;
          String stringWithoutQuotes = rpta.replaceAll('"', '');
          print("stringWithoutQuotes: " +
              stringWithoutQuotes); // Salida: Hello, World!
          _photo = stringWithoutQuotes;
        }
        notifyListeners();
      }
      var url2 =
          'https://prueba-164f3-default-rtdb.firebaseio.com/Description/$userId/.json?auth=$token';
      final response2 = await http.get(Uri.parse(url2));
      if (response.statusCode == 200) {
        if (json.decode(response2.body) != null) {
          _description = response2.body;
        }
        notifyListeners();
      }

      print("url: " + url);
      print('_photo: ' + _photo.toString());
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _photo = '';
    _token = '';
    _description = '';
    _userId = '';
    _correo = '';
    _expiryDate = DateTime.now();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> addDataUser(
      String token, String userId, String photoUrl, String desc) async {
    notifyListeners();
    final url =
        'https://prueba-164f3-default-rtdb.firebaseio.com/Photo/$userId.json?auth=$token';
    final url2 =
        'https://prueba-164f3-default-rtdb.firebaseio.com/Description/$userId.json?auth=$token';
    try {
      final response = await http.put(Uri.parse(url),
          body: json.encode(
            photoUrl,
          ));
      final response2 = await http.put(Uri.parse(url2),
          body: json.encode(
            desc,
          ));
      _photo = photoUrl;
      _description = desc;
      notifyListeners();
    } catch (error) {
      //_setFavValue(oldStatus);
    }
  }
}
