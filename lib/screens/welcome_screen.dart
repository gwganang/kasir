import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Animated Icon
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  child: Icon(
                    Icons.store,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Animated Title Text
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  child: Text(
                    'Selamat Datang',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),

                // Animated Subtitle Text
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  child: Text(
                    'di Aplikasi UDB Kasir!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),

                // Description Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeIn,
                    child: Text(
                      'Aplikasi ini digunakan untuk mengelola transaksi penjualan, barang, dan supplier. Memudahkan dalam pencatatan dan pemantauan inventaris serta penjualan secara efisien.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // "Masuk Aplikasi" Button with InkWell for Interaction
                CustomButton(
                  text: 'Masuk Aplikasi',
                  icon: Icons.login,
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
