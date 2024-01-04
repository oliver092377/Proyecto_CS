import 'package:app_alquileres/screens/edit_user_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'edit_products_screen.dart';

class PerfilScreen extends StatelessWidget {
  static const routeName = 'perfil-screen';
  String foto = "";

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);

    Widget buildTitleText(String title) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget buildBodyText(String title) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 5, 5),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (authData.photo != "")
              ClipOval(
                child: Image.network(
                  authData.photo,
                  width: 250.0,
                  height: 250.0,
                  fit: BoxFit.cover,
                ),
              ),
            if (authData.photo == "")
              ClipOval(
                child: Image.asset(
                  "images/descarga.png",
                  width: 250.0,
                  height: 250.0,
                  fit: BoxFit.cover,
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildTitleText('Email'),
                buildTitleText(''),
                GestureDetector(
                  onTap: () {
                    print('preseionaste el icono de telefono');
                  },
                  child: Container(
                    height: 40,
                    width: 5,
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      authData.correo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                buildBodyText(''),
                buildTitleText('INFO:'),
                buildBodyText(authData.description)
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditUserDataScreen.routeName);
              },
              child: Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
