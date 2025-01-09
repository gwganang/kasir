import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Menggunakan Center untuk memusatkan semua konten
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Memusatkan secara vertikal
            crossAxisAlignment: CrossAxisAlignment.center,  // Memusatkan secara horizontal
            children: <Widget>[
              SizedBox(height: 200),
              // Tombol Barang dengan Ikon
              CustomButton(
                text: 'Barang',
                icon: Icons.inventory_2, // Ikon untuk barang
                onPressed: () {
                  Navigator.pushNamed(context, '/barang');  // Navigasi ke halaman Barang
                },
              ),
              SizedBox(height: 20),

              // Tombol Supplier dengan Ikon
              CustomButton(
                text: 'Supplier',
                icon: Icons.business, // Ikon untuk supplier
                onPressed: () {
                  Navigator.pushNamed(context, '/supplier');  // Navigasi ke halaman Supplier
                },
              ),
              SizedBox(height: 20),

              // Tombol Penjualan dengan Ikon
              CustomButton(
                text: 'Penjualan',
                icon: Icons.shopping_cart, // Ikon untuk penjualan
                onPressed: () {
                  Navigator.pushNamed(context, '/penjualan');  // Navigasi ke halaman Penjualan
                },
              ),
              SizedBox(height: 200),  // Memberikan jarak sebelum tombol keluar

              // Tombol Keluar dengan Ikon
              CustomButton(
                text: 'Keluar',
                icon: Icons.exit_to_app, // Ikon untuk keluar
                onPressed: () {
                  Navigator.pushNamed(context, '/');  // Navigasi kembali ke halaman home
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
