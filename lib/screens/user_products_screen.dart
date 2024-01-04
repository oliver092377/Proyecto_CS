import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_products_screen.dart';
import '../providers/auth.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products-screen';
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final produtsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Articulos'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: produtsData.itens.length,
            itemBuilder: (_, i) => Column(
                  children: [
                    if (authData.userId == produtsData.itens[i].autor)
                      UserProductItem(
                        produtsData.itens[i].id,
                        produtsData.itens[i].title,
                        produtsData.itens[i].imageUrl01,
                      ),
                    Divider(
                      color: Colors.black,
                    )
                  ],
                )),
      ),
    );
  }
}
