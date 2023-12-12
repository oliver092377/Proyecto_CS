import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';

  @override
  Widget build(BuildContext context) {
    // Obtén la ruta actual de la pantalla
    final currentRoute = ModalRoute.of(context);

    // Verifica si la ruta actual no es nula y si tiene la propiedad 'settings'
    if (currentRoute != null && currentRoute.settings != null) {
      // Accede a la propiedad 'settings' de manera segura
      final productId = currentRoute.settings.arguments as String;

      // Utiliza try-catch para manejar el caso en que el producto no se encuentra
      try {
        final loadedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        Widget image_carousel = Container(
          height: 300,
          width: double.infinity,
          child: AnotherCarousel(
            boxFit: BoxFit.cover,
            images: [
              Image.network(loadedProduct.imageUrl01),
              Image.network(loadedProduct.imageUrl02),
              Image.network(loadedProduct.imageUrl03),
            ],
            autoplay: false,
            animationCurve: Curves.fastLinearToSlowEaseIn,
            dotSize: 4.0,
            dotColor: Colors.red,
            indicatorBgPadding: 4.0,
          ),
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(loadedProduct.title),
          ),
          body: ListView(
            children: <Widget>[
              image_carousel,
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.attach_money),
                    Text(
                      loadedProduct.price,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  'DESCRIPCIÓN',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ),
              Container(
                color: Colors.yellow,
                child: Row(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5)),
                  Icon(Icons.airport_shuttle),
                  Text('Kilometros: '),
                  Text(loadedProduct.km.toString()),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  'CONTACTO',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 25)),
                    IconButton(
                      icon: Icon(Icons.call),
                      color: Colors.green,
                      onPressed: () {
                        print('Presionaste el boton de llamar');
                      },
                    ),
                    Text('Teléfono: '),
                    Text(loadedProduct.phone),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          print('preseionaste el icono de telefono');
                        },
                        child: Container(
                          height: 40,
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
                    ))
                  ],
                ),
              )
            ],
          ),
        );
      } catch (error) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('Product not found'),
          ),
        );
      }
    } else {
      // Maneja el caso en que la ruta actual o sus configuraciones son nulas
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid route or settings'),
        ),
      );
    }
  }
}
