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
  List<dynamic> filteredPenjualanList = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  String selectedBarang = '';
  String barcode = '';
  String hargaSatuan = '';
  int jumlah = 1;  // Initial quantity is set to 1

  @override
  void initState() {
    super.initState();
    fetchPenjualanData();
    fetchBarangData(); // Load barang data for dropdown
  }

  Future<void> fetchPenjualanData() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.baseUrl + 'penjualan.php'));
      if (response.statusCode == 200) {
        setState(() {
          penjualanList = json.decode(response.body);
          filteredPenjualanList = List.from(penjualanList);  // Clone the list for filtering

          // Sorting by NONOTA (ascending order)
          filteredPenjualanList.sort((a, b) {
            return int.parse(a['NONOTA'].toString()).compareTo(int.parse(b['NONOTA'].toString()));
          });
        });
      } else {
        throw Exception('Failed to load penjualan');
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
        throw Exception('Failed to load barang');
      }
    } catch (e) {
      print(e);
    }
  }

  void filterPenjualan(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredPenjualanList = penjualanList
            .where((penjualan) => penjualan['BARANG'].toLowerCase().contains(query.toLowerCase()))
            .toList();

        // Sort the filtered list after applying filter
        filteredPenjualanList.sort((a, b) {
          return int.parse(a['NONOTA'].toString()).compareTo(int.parse(b['NONOTA'].toString()));
        });
      });
    } else {
      setState(() {
        filteredPenjualanList = List.from(penjualanList);  // Reset the filtered list
        // Sort the list again
        filteredPenjualanList.sort((a, b) {
          return int.parse(a['NONOTA'].toString()).compareTo(int.parse(b['NONOTA'].toString()));
        });
      });
    }
  }

  Future<void> addPenjualan() async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.baseUrl + 'penjualan.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NOBARCODE': barcode,
          'JUMLAH': jumlah.toString(),
        }),
      );
      if (response.statusCode == 200) {
        fetchPenjualanData(); // Refresh the list
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Penjualan berhasil ditambahkan'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
      } else {
        throw Exception('Gagal menambah penjualan');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  void showTambahPenjualanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Penjualan'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedBarang.isEmpty ? null : selectedBarang,
                    hint: Text('Pilih Barang'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBarang = newValue!;
                        var selectedItem = barangList.firstWhere((barang) => barang['NOBARCODE'] == selectedBarang);
                        barcode = selectedItem['NOBARCODE'];
                        hargaSatuan = selectedItem['HARGA'].toString();
                      });
                    },
                    items: barangList.map<DropdownMenuItem<String>>((dynamic barang) {
                      return DropdownMenuItem<String>(
                        value: barang['NOBARCODE'],
                        child: Text(barang['NAMA']),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text('No Barcode: $barcode', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('Harga Satuan: Rp $hargaSatuan', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.black),  // Set icon color to black
                        onPressed: () {
                          setState(() {
                            if (jumlah > 1) jumlah--;
                          });
                        },
                      ),
                      Text(
                        '$jumlah',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.black),  // Set icon color to black
                        onPressed: () {
                          setState(() {
                            jumlah++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Reset the form when canceled
                setState(() {
                  selectedBarang = '';
                  barcode = '';
                  hargaSatuan = '';
                  jumlah = 1; // Reset quantity to 1
                });
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (selectedBarang.isNotEmpty && jumlah > 0) {
                  addPenjualan();
                  // Reset the form after successful addition
                  setState(() {
                    selectedBarang = '';
                    barcode = '';
                    hargaSatuan = '';
                    jumlah = 1; // Reset quantity to 1
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Harap isi semua data'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void showPenjualanDetails(Map<String, dynamic> penjualan) {
    double total = double.tryParse(penjualan['TOTAL'].toString()) ?? 0.0;
    String formattedTotal = total.toStringAsFixed(2).endsWith('.00') ? total.toStringAsFixed(0) : total.toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Penjualan', style: TextStyle(color: Colors.black)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No Nota          : ${penjualan['NONOTA']}', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Nama Barang : ${penjualan['BARANG']}', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Jumlah            : ${penjualan['JUMLAH']}', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Total                : Rp $formattedTotal', style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup', style: TextStyle(color: Colors.black)),
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
        title: Text('Data Penjualan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: filterPenjualan,
              decoration: InputDecoration(
                labelText: 'Cari Barang',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredPenjualanList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: filteredPenjualanList.length,
                itemBuilder: (context, index) {
                  final penjualan = filteredPenjualanList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No Nota: ${penjualan['NONOTA']}', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Nama Barang: ${penjualan['BARANG']}'),
                          SizedBox(height: 8),
                          Text('Jumlah: ${penjualan['JUMLAH']}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                      onTap: () => showPenjualanDetails(penjualan),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: showTambahPenjualanDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              child: SizedBox(
                width: double.infinity,  // Makes the button span the full width
                child: Text(
                  'Tambah Penjualan',
                  textAlign: TextAlign.center,  // Ensures the text is centered
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
