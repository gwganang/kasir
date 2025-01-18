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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBarangData();
  }

  Future<void> fetchBarangData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
          Uri.parse(AppConfig.baseUrl + 'barang.php'));

      if (response.statusCode == 200) {
        setState(() {
          barangList = json.decode(response.body);
          filteredBarangList = barangList;
        });
      } else {
        throw Exception('Gagal mengambil data barang');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk filter barang berdasarkan nama atau barcode
  void filterBarang(String query) {
    setState(() {
      filteredBarangList = barangList.where((barang) {
        return barang['NAMA'].toLowerCase().contains(query.toLowerCase()) ||
            barang['NOBARCODE'].contains(query);
      }).toList();
    });
  }

  // Fungsi untuk menambah barang
  Future<void> addBarang(String noBarcode, String nama, double harga,
      int stok) async {
    if (noBarcode.isEmpty || nama.isEmpty || harga <= 0 || stok < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Input tidak valid")));
      return;
    }
    setState(() {
      isLoading = true;
    });
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
        _showSuccessSnackbar("Barang berhasil ditambah");
      } else {
        throw Exception('Gagal menambah barang');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk mengedit barang
  Future<void> _editBarang(String noBarcode, String nama, double harga,
      int stok) async {
    if (nama.isEmpty || harga <= 0 || stok < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Input tidak valid")));
      return;
    }
    setState(() {
      isLoading = true;
    });
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
        _showSuccessSnackbar("Data barang berhasil diperbarui");
      } else {
        throw Exception('Gagal memperbarui data barang');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menghapus barang
  Future<void> deleteBarang(String noBarcode) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.delete(
        Uri.parse(AppConfig.baseUrl + 'barang.php?NOBARCODE=$noBarcode'),
      );

      if (response.statusCode == 200) {
        fetchBarangData(); // Refresh the list
        _showSuccessSnackbar("Data barang berhasil dihapus");
      } else {
        throw Exception('Gagal menghapus data barang');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
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

  // Fungsi untuk menampilkan notifikasi sukses
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));
  }

  // Dialog konfirmasi sebelum menghapus barang
  void _showDeleteConfirmationDialog(BuildContext context, String noBarcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus barang ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                deleteBarang(noBarcode);
                Navigator.pop(context); // Tutup dialog
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
        title: Text("Barang"),
        elevation: 5.0,
        backgroundColor: Colors.blueAccent,
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
      body: isLoading
          ? Center(
          child: CircularProgressIndicator()) // Display loading indicator
          : Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  filterBarang(query);
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
                  ? Center(child: Text("No data available"))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Jumlah kolom
                  crossAxisSpacing: 10.0, // Jarak antar kolom
                  mainAxisSpacing: 10.0, // Jarak antar baris
                  childAspectRatio: 1.25, // Perbandingan tinggi dan lebar
                ),
                itemCount: filteredBarangList.length,
                itemBuilder: (context, index) {
                  final item = filteredBarangList[index];
                  bool isLowStock = item['STOK'] < 25;

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blueGrey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item['NAMA'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Harga: ${item['HARGA']}',
                            style: TextStyle(
                              color: Colors.blueGrey.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Stok: ${item['STOK']}',
                            style: TextStyle(
                              color: isLowStock ? Colors.red : Colors.blueGrey
                                  .shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditBarangDialog(
                                      context, item['NOBARCODE']);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, item['NOBARCODE']);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBarangDialog(context);
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Barang"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noBarcodeController,
                decoration: InputDecoration(labelText: 'No. Barcode'),
              ),
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
              ),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Harga'),
              ),
              TextField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stok'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                addBarang(
                  noBarcodeController.text,
                  namaController.text,
                  double.tryParse(hargaController.text) ?? 0,
                  int.tryParse(stokController.text) ?? 0,
                );
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog edit barang
  void _showEditBarangDialog(BuildContext context, String noBarcode) {
    final namaController = TextEditingController();
    final hargaController = TextEditingController();
    final stokController = TextEditingController();

    // Isi default nilai
    final item = barangList.firstWhere((element) =>
    element['NOBARCODE'] == noBarcode);

    namaController.text = item['NAMA'];
    hargaController.text = item['HARGA'].toString();
    stokController.text = item['STOK'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Barang"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
              ),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Harga'),
              ),
              TextField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stok'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editBarang(
                  item['NOBARCODE'],
                  namaController.text,
                  double.tryParse(hargaController.text) ?? 0,
                  int.tryParse(stokController.text) ?? 0,
                );
                Navigator.pop(context); // Tutup dialog
              },
              child: Text("Perbarui"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: Text("Batal"),
            ),
          ],
        );
      },
    );
  }
}
