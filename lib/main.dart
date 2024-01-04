import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'providers/products.dart';
import 'package:provider/provider.dart';
import 'screens/nosotros_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/edit_user_data_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/edit_products_screen.dart';
import 'providers/auth.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.itens),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Alquileres',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : HomeScreen(),
                ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            ProductsOverviewScreen.routename: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            NosotrosScreen.routeName: (ctx) => NosotrosScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
            PerfilScreen.routeName: (ctx) => PerfilScreen(),
            EditUserDataScreen.routeName: (ctx) => EditUserDataScreen(),
          },
        ),
      ),
    );
  }
}
