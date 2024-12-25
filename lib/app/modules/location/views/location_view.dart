import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController locationNameController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi'),
        actions: [
          IconButton(
            onPressed: controller.resetLocation,
            icon: const Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Titik Koordinat',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Obx(() => Text(
                          controller.locationMessage.value,
                          style: const TextStyle(fontSize: 18),
                        )),
                    const SizedBox(height: 20),
                    const Text(
                      'Nama Lokasi',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            controller.address.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        )),
                    const SizedBox(height: 20),
                    const Text(
                      'Cari Lokasi Berdasarkan Nama',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: locationNameController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Nama Lokasi',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.searchLocation(locationNameController.text);
                      },
                      child: const Text('Cari Lokasi'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Atau Cari Lokasi Secara Otomatis',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: controller.getCurrentLocation,
                      child: const Text('Lokasi Otomatis'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: controller.openGoogleMaps,
                      child: const Text('Buka Google Maps'),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Image.asset(
                  'assets/kantor.png', // Path ke gambar lokal
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Kunjungi Kantor Pusat Kami',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}