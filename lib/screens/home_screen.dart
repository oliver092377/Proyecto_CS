import 'package:flutter/material.dart';
import '../screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class HomeScreen extends StatelessWidget {
  static const routeName = 'home-screen';
  selectProductsOverview(BuildContext context) {
    Navigator.of(context).pushNamed(ProductsOverviewScreen.routename);
  }

  final background = Container(
    decoration: BoxDecoration(
        image: DecorationImage(
      image: AssetImage('images/fondo.png'),
      fit: BoxFit.cover,
    )),
  );
  final whiteOpacity = Container(
    color: Colors.white12,
  );
  final logo = Image.asset(
    'images/logo.png',
    width: 300,
    height: 300,
  );
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          background,
          whiteOpacity,
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SafeArea(
                    child: Column(
                      children: <Widget>[
                        logo,
                      ],
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _showErrorDialog(List<String> arreglo) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(arreglo[1]),
              content: Text(arreglo[0]),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // log user in
        List<String> rpta = await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);

        if (rpta[0] != '') _showErrorDialog(rpta);
      } else {
        //sign user up
        if (_passwordController.text == _confirmPasswordController.text) {
          List<String> rpta = await Provider.of<Auth>(context, listen: false)
              .signup(_authData['email']!, _authData['password']!);
          if (rpta[0] != '') {
            _showErrorDialog(rpta);
            if (rpta[1] == 'Mensaje') _authMode = AuthMode.Login;
          }
        } else {
          List<String> rpta = [
            "Las contraseñas no coinciden",
            "Ocurrió un error"
          ];
          _showErrorDialog(rpta);
        }
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Este mail ya está en uso';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Este no es un email válido';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'El password es muy debil';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'No se encontró usuario con este mail';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Password inválido';
      }
      List<String> arreglo = [errorMessage, 'Ocurrió un error'];
      _showErrorDialog(arreglo);
    } catch (error) {
      const errorMessage = 'No se pudo autentificar, intente más tarde';
      List<String> arreglo = [errorMessage, 'Ocurrió un error'];
      _showErrorDialog(arreglo);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 400 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 400 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Mail inválido';
                      }
                    }
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _authData['email'] = value;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Contraseña  es muy corta';
                      }
                    }
                  },
                  onSaved: (value) {
                    if (value != null) _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration:
                        InputDecoration(labelText: 'Confirmar contraseña'),
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Contraseñas no coinciden';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  TextButton(
                    child: Text(_authMode == AuthMode.Login
                        ? 'INICIO DE SESION'
                        : 'SING UP'),
                    onPressed: _submit,
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder?>(
                          (Set<MaterialState> states) {
                            return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            );
                          },
                        ),
                        padding: MaterialStateProperty.resolveWith<
                            EdgeInsetsGeometry?>(
                          (Set<MaterialState> states) {
                            return EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 8.0,
                            );
                          },
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        textStyle:
                            MaterialStateProperty.resolveWith<TextStyle?>(
                          (Set<MaterialState> states) {
                            // Devuelve el estilo de texto deseado para el estado predeterminado
                            return TextStyle(
                              color: Colors.black,
                            );
                          },
                        )),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${AuthMode == AuthMode.Login ? 'REGISTRO' : 'LOGIN'} NUEVO'),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith<
                          EdgeInsetsGeometry?>(
                        (Set<MaterialState> states) {
                          return EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 4.0,
                          );
                        },
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                        (Set<MaterialState> states) {
                          // Devuelve el estilo de texto deseado para el estado predeterminado
                          return TextStyle(
                            color: Colors.white,
                          );
                        },
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
