import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class SupplierScreen extends StatefulWidget {
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  List<dynamic> supplierList = [];

  @override
  void initState() {
    super.initState();
    fetchSupplierData();
  }

  Future<void> fetchSupplierData() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.baseUrl + 'supplier.php'));

      if (response.statusCode == 200) {
        setState(() {
          supplierList = json.decode(response.body);
        });
      } else {
        throw Exception('Gagal mengambil data supplier');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addSupplier(String nama, String alamat, String nohp) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.baseUrl + 'supplier.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NAMA': nama,
          'ALAMAT': alamat,
          'NOHP': nohp,
        }),
      );

      if (response.statusCode == 200) {
        fetchSupplierData(); // Refresh the list
      } else {
        throw Exception('Gagal menambah supplier');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteSupplier(int idSup) async {
    try {
      final response = await http.delete(
        Uri.parse(AppConfig.baseUrl + 'supplier.php?IDSUP=$idSup'),
      );

      if (response.statusCode == 200) {
        fetchSupplierData(); // Refresh the list
      } else {
        throw Exception('Gagal menghapus supplier');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplier"),
      ),
      body: supplierList.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
        itemCount: supplierList.length,
        itemBuilder: (context, index) {
          final item = supplierList[index];
          return ListTile(
            title: Text(item['NAMA']),
            subtitle: Text('Alamat: ${item['ALAMAT']} - No HP: ${item['NOHP']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Hapus supplier
                deleteSupplier(item['IDSUP']);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSupplierDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Dialog untuk menambahkan supplier baru
  void _showAddSupplierDialog(BuildContext context) {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final nohpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tambah Supplier"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: "Nama Supplier"),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: "Alamat"),
            ),
            TextField(
              controller: nohpController,
              decoration: InputDecoration(labelText: "No HP"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              addSupplier(
                namaController.text,
                alamatController.text,
                nohpController.text,
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
}
