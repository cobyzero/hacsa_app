import 'package:adhesivepro/presentation/cart/cart_screen.dart';
import 'package:adhesivepro/presentation/product_authentication/product_authentication.dart';
import 'package:flutter/material.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/qr_scanner/qr_scanner.dart';
import '../presentation/product_catalog/product_catalog.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String productDetail = '/product-detail';
  static const String splash = '/splash-screen';
  static const String userProfile = '/user-profile';
  static const String login = '/login-screen';
  static const String qrScanner = '/qr-scanner';
  static const String productCatalog = '/product-catalog';
  static const String productAuthentication = '/product-authentication';
  static const String cart = '/cart';
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    productDetail: (context) => const ProductDetail(),
    splash: (context) => const SplashScreen(),
    userProfile: (context) => const UserProfile(),
    login: (context) => const LoginScreen(),
    qrScanner: (context) => const QrScanner(),
    productCatalog: (context) => const ProductCatalog(),
    productAuthentication: (context) => const ProductAuthentication(),
    cart: (context) => const CartScreen(),
    // TODO: Add your other routes here
  };
}
