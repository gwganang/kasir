import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centering vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Centering horizontally
            children: <Widget>[
              // Large Title Text - "Selamat Datang"
              Text(
                'Selamat Datang',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Space between the titles

              // Subtitle Text - "di Aplikasi UDB Kasir!"
              Text(
                'di Aplikasi UDB Kasir!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40), // Space before the description and button

              // Description Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Aplikasi ini digunakan untuk mengelola transaksi penjualan, barang, dan supplier. Memudahkan dalam pencatatan dan pemantauan inventaris serta penjualan secara efisien.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 30), // Space between description and button

              // "Masuk Aplikasi" Button
              CustomButton(
                text: 'Masuk Aplikasi',
                icon: Icons.login,
                onPressed: () {
                  // Navigasi ke halaman dashboard
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
