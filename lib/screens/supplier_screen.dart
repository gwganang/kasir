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
  List<dynamic> filteredSupplierList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;  // Declare the isLoading variable

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
          filteredSupplierList = supplierList;
        });
      } else {
        throw Exception('Gagal mengambil data supplier');
      }
    } catch (e) {
      print(e);
    }
  }

  void filterSupplier(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredSupplierList = supplierList
            .where((supplier) => supplier['NAMA'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredSupplierList = supplierList;
      });
    }
  }

  Future<void> addSupplier(String nama, String alamat, String nohp) async {
    setState(() {
      isLoading = true;
    });

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
        fetchSupplierData();
        _showSuccessSnackbar("Supplier berhasil ditambah");
      } else {
        throw Exception('Gagal menambah supplier');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> deleteSupplier(int idSup) async {
    try {
      final response = await http.delete(
        Uri.parse(AppConfig.baseUrl + 'supplier.php?IDSUP=$idSup'),
      );

      if (response.statusCode == 200) {
        fetchSupplierData();
        showNotification("Data supplier berhasil dihapus", Colors.green);
      } else {
        throw Exception('Gagal menghapus data supplier');
      }
    } catch (e) {
      showNotification("Gagal menghapus data supplier", Colors.red);
      print(e);
    }
  }

  Future<void> _editSupplier(int idSup, String nama, String alamat, String nohp) async {
    try {
      final response = await http.put(
        Uri.parse(AppConfig.baseUrl + 'supplier.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'IDSUP': idSup,
          'NAMA': nama,
          'ALAMAT': alamat,
          'NOHP': nohp,
        }),
      );

      if (response.statusCode == 200) {
        fetchSupplierData();
        showNotification("Data supplier berhasil diperbarui", Colors.green);
      } else {
        throw Exception('Gagal memperbarui data supplier');
      }
    } catch (e) {
      showNotification("Gagal memperbarui data supplier", Colors.red);
      print(e);
    }
  }

  void showNotification(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    ));
  }

  void confirmDeleteSupplier(BuildContext context, int idSup) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus data supplier ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteSupplier(idSup);
              },
              child: Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplier"),
        elevation: 5.0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                filterSupplier(query);
              },
              decoration: InputDecoration(
                labelText: 'Cari Supplier',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredSupplierList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredSupplierList.length,
              itemBuilder: (context, index) {
                final item = filteredSupplierList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text(
                        item['NAMA'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Alamat: ${item['ALAMAT']} \nNo HP: ${item['NOHP']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditSupplierDialog(context, item['IDSUP']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              confirmDeleteSupplier(context, item['IDSUP']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSupplierDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

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

  void _showEditSupplierDialog(BuildContext context, int idSup) {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final nohpController = TextEditingController();

    final supplier = supplierList.firstWhere((supplier) => supplier['IDSUP'] == idSup);
    namaController.text = supplier['NAMA'];
    alamatController.text = supplier['ALAMAT'];
    nohpController.text = supplier['NOHP'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Supplier"),
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
              _editSupplier(
                idSup,
                namaController.text,
                alamatController.text,
                nohpController.text,
              );
              Navigator.pop(context);
            },
            child: Text("Perbarui"),
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
