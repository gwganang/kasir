import 'package:flutter/material.dart';
import 'theme/app_theme.dart'; // Import tema
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/barang_screen.dart';
import 'screens/supplier_screen.dart';
import 'screens/penjualan_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDB Kasir',
      theme: appTheme, // Terapkan tema
      home: HomeScreen(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/barang': (context) => BarangScreen(),
        '/supplier': (context) => SupplierScreen(),
        '/penjualan': (context) => PenjualanScreen(),
      },
    );
  }
}
