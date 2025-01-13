import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Tombol Barang dengan Animasi
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  child: CustomButton(
                    text: 'Barang',
                    icon: Icons.inventory_2,
                    onPressed: () {
                      Navigator.pushNamed(context, '/barang');  // Navigasi ke halaman Barang
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Tombol Supplier dengan Animasi
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  child: CustomButton(
                    text: 'Supplier',
                    icon: Icons.business,
                    onPressed: () {
                      Navigator.pushNamed(context, '/supplier');  // Navigasi ke halaman Supplier
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Tombol Penjualan dengan Animasi
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  child: CustomButton(
                    text: 'Penjualan',
                    icon: Icons.shopping_cart,
                    onPressed: () {
                      Navigator.pushNamed(context, '/penjualan');  // Navigasi ke halaman Penjualan
                    },
                  ),
                ),
                SizedBox(height: 200), // Jarak sebelum tombol keluar

                // Tombol Keluar dengan Animasi
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  child: CustomButton(
                    text: 'Keluar',
                    icon: Icons.exit_to_app,
                    onPressed: () {
                      Navigator.pushNamed(context, '/');  // Navigasi kembali ke halaman home
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
