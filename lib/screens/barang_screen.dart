import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class BarangScreen extends StatefulWidget {
  @override
  _BarangScreenState createState() => _BarangScreenState();
}

class _BarangScreenState extends State<BarangScreen> {
  List<dynamic> barangList = [];

  @override
  void initState() {
    super.initState();
    fetchBarangData();
  }

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

  // Fungsi untuk menambah barang
  Future<void> addBarang(String noBarcode, String nama, double harga, int stok) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.baseUrl + 'barang.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NOBARCODE': noBarcode,
          'NAMA': nama,
          'HARGA': harga,
          'STOK': stok,
        }),
      );

      if (response.statusCode == 200) {
        fetchBarangData(); // Refresh the list
      } else {
        throw Exception('Gagal menambah barang');
      }
    } catch (e) {
      print(e);
    }
  }

  // Fungsi untuk menampilkan dialog tambah barang
  void _showAddBarangDialog(BuildContext context) {
    final noBarcodeController = TextEditingController();
    final namaController = TextEditingController();
    final hargaController = TextEditingController();
    final stokController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tambah Barang"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noBarcodeController,
              decoration: InputDecoration(labelText: "No Barcode"),
            ),
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: "Nama Barang"),
            ),
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Harga"),
            ),
            TextField(
              controller: stokController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Stok"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              addBarang(
                noBarcodeController.text,
                namaController.text,
                double.parse(hargaController.text),
                int.parse(stokController.text),
              );
              Navigator.pop(context);
            },
            child: Text("Tambah"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteBarang(String noBarcode) async {
    try {
      final response = await http.delete(
        Uri.parse(AppConfig.baseUrl + 'barang.php?NOBARCODE=$noBarcode'),
      );

      if (response.statusCode == 200) {
        fetchBarangData(); // Refresh the list
      } else {
        throw Exception('Gagal menghapus barang');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barang"),
      ),
      body: barangList.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
        itemCount: barangList.length,
        itemBuilder: (context, index) {
          final item = barangList[index];
          return ListTile(
            title: Text(item['NAMA']),
            subtitle: Text('Harga: ${item['HARGA']} - Stok: ${item['STOK']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Hapus barang
                deleteBarang(item['NOBARCODE']);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBarangDialog(context); // Menampilkan dialog tambah barang
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
