import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class TransaksiScreen extends StatefulWidget {
  @override
  _TransaksiScreenState createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TextEditingController jumlahController = TextEditingController();
  String? selectedBarang;
  List<dynamic> barangList = [];

  @override
  void initState() {
    super.initState();
    fetchBarangData();
  }

  // Fetch barang data from the API
  Future<void> fetchBarangData() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.baseUrl + 'barang.php'));

      if (response.statusCode == 200) {
        setState(() {
          barangList = json.decode(response.body);
        });
      } else {
        throw Exception('Gagal mengambil data barang');
      }
    } catch (e) {
      print(e);
    }
  }

  // Add transaction to the backend
  Future<void> addTransaction() async {
    if (selectedBarang == null || jumlahController.text.isEmpty) {
      // Show an error if the selection or jumlah is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon pilih barang dan masukkan jumlah')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(AppConfig.baseUrl + 'penjualan.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NOBARCODE': selectedBarang,
          'JUMLAH': jumlahController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Close the transaksi screen after successful submission
      } else {
        throw Exception('Gagal menambah transaksi');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting barang
            DropdownButton<String>(
              hint: Text("Pilih Barang"),
              value: selectedBarang,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBarang = newValue;
                });
              },
              items: barangList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['NOBARCODE'],
                  child: Text(item['NAMA']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Input field for jumlah
            TextField(
              controller: jumlahController,
              decoration: InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTransaction,
              child: Text('Tambah Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
