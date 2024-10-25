import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaksi Penumpang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TransaksiScreen(),
    );
  }
}

class Transaksi {
  final String kodeTransaksi;
  final String kodePenumpang;
  final String namaPenumpang;
  final String jenisPenumpang;
  final String platNomor;
  final String supir;
  final double biayaAwal;
  final double biayaPerKilometer;
  final double jumlahKilometer;

  Transaksi({
    required this.kodeTransaksi,
    required this.kodePenumpang,
    required this.namaPenumpang,
    required this.jenisPenumpang,
    required this.platNomor,
    required this.supir,
    required this.biayaAwal,
    required this.biayaPerKilometer,
    required this.jumlahKilometer,
  });

  double hitungTotalBayar() {
    double kilometerDikenakanBiaya = jumlahKilometer;

    // Pengaturan kilometer gratis berdasarkan jenis penumpang
    if (jenisPenumpang == "VIP") {
      kilometerDikenakanBiaya = (jumlahKilometer > 5) ? jumlahKilometer - 5 : 0;
    } else if (jenisPenumpang == "GOLD") {
      kilometerDikenakanBiaya = (jumlahKilometer > 2) ? jumlahKilometer - 2 : 0;
    }

    // Hitung Total Bayar
    return biayaAwal + (biayaPerKilometer * kilometerDikenakanBiaya);
  }
}

class TransaksiScreen extends StatefulWidget {
  @override
  _TransaksiScreenState createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TextEditingController _kodeTransaksiController = TextEditingController();
  final TextEditingController _kodePenumpangController = TextEditingController();
  final TextEditingController _namaPenumpangController = TextEditingController();
  String _jenisPenumpang = "GOLD";  // Set default ke GOLD
  final TextEditingController _platNomorController = TextEditingController();
  final TextEditingController _supirController = TextEditingController();
  final TextEditingController _biayaAwalController = TextEditingController();
  final TextEditingController _biayaPerKilometerController = TextEditingController();
  final TextEditingController _jumlahKilometerController = TextEditingController();

  double? _totalBayar;

  void _hitungTotalBayar() {
    final transaksi = Transaksi(
      kodeTransaksi: _kodeTransaksiController.text,
      kodePenumpang: _kodePenumpangController.text,
      namaPenumpang: _namaPenumpangController.text,
      jenisPenumpang: _jenisPenumpang,
      platNomor: _platNomorController.text,
      supir: _supirController.text,
      biayaAwal: double.parse(_biayaAwalController.text),
      biayaPerKilometer: double.parse(_biayaPerKilometerController.text),
      jumlahKilometer: double.parse(_jumlahKilometerController.text),
    );

    setState(() {
      _totalBayar = transaksi.hitungTotalBayar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaksi Penumpang"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _kodeTransaksiController,
              decoration: InputDecoration(labelText: "Kode Transaksi"),
            ),
            TextField(
              controller: _kodePenumpangController,
              decoration: InputDecoration(labelText: "Kode Penumpang"),
            ),
            TextField(
              controller: _namaPenumpangController,
              decoration: InputDecoration(labelText: "Nama Penumpang"),
            ),
            DropdownButtonFormField<String>(
              value: _jenisPenumpang,
              decoration: InputDecoration(labelText: "Jenis Penumpang"),
              items: ["VIP", "GOLD"].map((jenis) {
                return DropdownMenuItem(
                  value: jenis,
                  child: Text(jenis),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _jenisPenumpang = value!;
                });
              },
            ),
            TextField(
              controller: _platNomorController,
              decoration: InputDecoration(labelText: "Plat Nomor"),
            ),
            TextField(
              controller: _supirController,
              decoration: InputDecoration(labelText: "Supir"),
            ),
            TextField(
              controller: _biayaAwalController,
              decoration: InputDecoration(labelText: "Biaya Awal"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _biayaPerKilometerController,
              decoration: InputDecoration(labelText: "Biaya Per Kilometer"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _jumlahKilometerController,
              decoration: InputDecoration(labelText: "Jumlah Kilometer"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hitungTotalBayar,
              child: Text("Hitung Total Bayar"),
            ),
            SizedBox(height: 20),
            if (_totalBayar != null)
              Text(
                "Total Bayar: Rp ${_totalBayar!.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
