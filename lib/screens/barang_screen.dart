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
  List<dynamic> filteredBarangList = [];
  TextEditingController searchController = TextEditingController();

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
          filteredBarangList = barangList; // Set the filtered list to all data initially
        });
      } else {
        throw Exception('Gagal mengambil data barang');
      }
    } catch (e) {
      print(e);
    }
  }

  // Fungsi untuk filter barang berdasarkan nama atau barcode
  void filterBarang(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredBarangList = barangList
            .where((barang) => barang['NAMA'].toLowerCase().contains(query.toLowerCase()) || barang['NOBARCODE'].contains(query))
            .toList();
      });
    } else {
      setState(() {
        filteredBarangList = barangList; // Jika tidak ada query, tampilkan semua barang
      });
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

  // Fungsi untuk mengedit barang
  Future<void> _editBarang(String noBarcode, String nama, double harga, int stok) async {
    try {
      final response = await http.put(
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Barang berhasil diperbarui")),
        );
      } else {
        throw Exception('Gagal memperbarui barang');
      }
    } catch (e) {
      print(e);
    }
  }

  // Fungsi untuk menghapus barang
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

  // Fungsi untuk menyortir barang berdasarkan pilihan
  void sortBarang(String option) {
    setState(() {
      if (option == 'Nama (A-Z)') {
        filteredBarangList.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
      } else if (option == 'Harga (Murah ke Mahal)') {
        filteredBarangList.sort((a, b) => a['HARGA'].compareTo(b['HARGA']));
      } else if (option == 'Stok (Banyak ke Sedikit)') {
        filteredBarangList.sort((a, b) => b['STOK'].compareTo(a['STOK']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barang"),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Urutkan Berdasarkan"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text("Nama (A-Z)"),
                          onTap: () {
                            sortBarang('Nama (A-Z)');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text("Harga (Murah ke Mahal)"),
                          onTap: () {
                            sortBarang('Harga (Murah ke Mahal)');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text("Stok (Banyak ke Sedikit)"),
                          onTap: () {
                            sortBarang('Stok (Banyak ke Sedikit)');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                filterBarang(query); // Menjalankan fungsi filter saat input berubah
              },
              decoration: InputDecoration(
                labelText: 'Cari Barang',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredBarangList.isEmpty
                ? Center(child: CircularProgressIndicator()) // Loading indicator
                : ListView.builder(
              itemCount: filteredBarangList.length,
              itemBuilder: (context, index) {
                final item = filteredBarangList[index];
                return ListTile(
                  title: Text(item['NAMA']),
                  subtitle: Row(
                    children: [
                      Text('Harga: ${item['HARGA']} - '),
                      Text(
                        'Stok: ${item['STOK']}',
                        style: TextStyle(
                          color: item['STOK'] < 25 ? Colors.red : Colors.black, // Warna merah jika stok < 25
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditBarangDialog(context, item['NOBARCODE']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteBarang(item['NOBARCODE']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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

  // Fungsi untuk menampilkan dialog edit barang
  void _showEditBarangDialog(BuildContext context, String noBarcode) {
    final namaController = TextEditingController();
    final hargaController = TextEditingController();
    final stokController = TextEditingController();

    // Mengisi controller dengan data barang yang akan diedit
    final barang = barangList.firstWhere((barang) => barang['NOBARCODE'] == noBarcode);
    namaController.text = barang['NAMA'];
    hargaController.text = barang['HARGA'].toString();
    stokController.text = barang['STOK'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Barang"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              _editBarang(
                noBarcode,
                namaController.text,
                double.parse(hargaController.text),
                int.parse(stokController.text),
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
