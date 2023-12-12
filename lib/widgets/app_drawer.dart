import 'package:flutter/material.dart';
import '../screens/products_overview_screen.dart';
import '../screens/nosotros_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.red,
        child: Column(children: <Widget>[
          AppBar(
            title: Text('Drawer'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.shop),
              title: Text('Autos'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ProductsOverviewScreen.routename);
              },
            ),
          ),
          Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.perm_identity),
              title: Text('Nosotros'),
              onTap: () {
                Navigator.of(context).pushNamed(NosotrosScreen.routeName);
              },
            ),
          ),
          Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
          Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Product Manager'),
              onTap: () {
                Navigator.of(context).pushNamed(UserProductsScreen.routeName);
              },
            ),
          )
        ]),
      ),
    );
  }
}
