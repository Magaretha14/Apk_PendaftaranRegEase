import 'package:aplikasipendaftaranklinik/main.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/admin/homepage_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../themes/custom_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RiwayatPasienMasuk());
}

class RiwayatPasienMasuk extends StatefulWidget {
  const RiwayatPasienMasuk({super.key});

  @override
  State<RiwayatPasienMasuk> createState() => _RiwayatPasienMasukState();
}

class _RiwayatPasienMasukState extends State<RiwayatPasienMasuk> {
  final Stream<QuerySnapshot> _streamRiwayatPasienMasuk =
      FirebaseFirestore.instance.collection("riwayat pasien masuk").snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePageAdmin(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(titleRiwayatPasienMasuk),
      ),
      body: buildListRiwayat(size),
    );
  }

  Widget buildListRiwayat(size) {
    return StreamBuilder(
        stream: _streamRiwayatPasienMasuk,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum Ada Data!"),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot data) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Nama Pasien"),
                                  Text(
                                    "${data['nama pasien']}",
                                    style: TextStyle(
                                        color: colorPinkText,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Masuk"),
                                  Text(
                                    "${data['waktu antrian']}",
                                    style: TextStyle(
                                        color: colorPinkText,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Keluar"),
                                  Text(
                                    "${data['selesai antrian']}",
                                    style: TextStyle(
                                        color: colorPinkText,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              }).toList(),
            );
          }
        });
  }
}
