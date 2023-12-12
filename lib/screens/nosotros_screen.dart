import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//flutter_launch

class NosotrosScreen extends StatelessWidget {
  static const routeName = 'nosotros-screen';
  @override
  Widget build(BuildContext context) {
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
        title: Text('Nosotros'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'images/fondo.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildTitleText('Contacto'),
                buildBodyText('Enviamos un mail a: '),
                InkWell(
                  onTap: () {
                    launch(
                        "mailto:<olioamn@gmail.com>?subject=Quiero Anunciarme");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'olioamn@gmail.com',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                buildBodyText('o un Whatsapp: '),
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
                      'Whatsaap',
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
                buildBodyText('uno, dos, tres')
              ],
            )
          ],
        ),
      ),
    );
  }
}
