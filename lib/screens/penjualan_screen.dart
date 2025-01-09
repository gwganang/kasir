import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class PenjualanScreen extends StatefulWidget {
  @override
  _PenjualanScreenState createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  List<dynamic> penjualanList = [];
  List<dynamic> barangList = [];
  String? selectedBarang;
  TextEditingController barcodeController = TextEditingController();
  TextEditingController namaBarangController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPenjualanData();
    fetchBarangData();
  }

  Future<void> fetchPenjualanData() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.baseUrl + 'penjualan.php'));

      if (response.statusCode == 200) {
        setState(() {
          penjualanList = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load penjualan data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBarangData() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.baseUrl + 'barang.php'));

      if (response.statusCode == 200) {
        setState(() {
          barangList = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load barang data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addPenjualan() async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.baseUrl + 'penjualan.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NOBARCODE': barcodeController.text,
          'JUMLAH': jumlahController.text,
        }),
      );

      if (response.statusCode == 200) {
        fetchPenjualanData(); // Refresh the list after adding
        print('Penjualan added successfully');
      } else {
        throw Exception('Failed to add penjualan');
      }
    } catch (e) {
      print(e);
    }
  }

  void onBarangChanged(String? value) {
    if (value != null) {
      final selected = barangList.firstWhere((item) => item['NOBARCODE'] == value);
      setState(() {
        selectedBarang = value;
        barcodeController.text = selected['NOBARCODE'];
        namaBarangController.text = selected['NAMA'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penjualan'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Tambah Transaksi Penjualan'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dropdown for selecting Barang
                      DropdownButton<String>(
                        hint: Text('Pilih Barang'),
                        value: selectedBarang,
                        onChanged: onBarangChanged,
                        items: barangList.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item['NOBARCODE'],
                            child: Text(item['NAMA']),
                          );
                        }).toList(),
                      ),
                      // Auto-filled Name of Barang
                      TextField(
                        controller: namaBarangController,
                        decoration: InputDecoration(labelText: 'Nama Barang'),
                        enabled: false,  // Disabling editing for the name
                      ),
                      // Auto-filled Barcode Number
                      TextField(
                        controller: barcodeController,
                        decoration: InputDecoration(labelText: 'No Barcode'),
                        enabled: false,  // Disabling editing for the barcode
                      ),
                      // Input for Quantity
                      TextField(
                        controller: jumlahController,
                        decoration: InputDecoration(labelText: 'Jumlah'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        addPenjualan();
                        Navigator.of(context).pop();
                      },
                      child: Text('Simpan'),
                    ),
                  ],
                ),
              );
            },
            child: Text('Tambah Transaksi'),
          ),
          Expanded(
            child: penjualanList.isEmpty
                ? Center(child: CircularProgressIndicator())  // Loading indicator
                : ListView.builder(
              itemCount: penjualanList.length,
              itemBuilder: (context, index) {
                final item = penjualanList[index];
                return ListTile(
                  title: Text(item['BARANG']),
                  subtitle: Text('Jumlah: ${item['JUMLAH']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
