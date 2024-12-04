import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  var currentPosition = Rxn<Position>();
  var locationMessage = "Belum diatur".obs; // Default value
  var address = "Belum diatur".obs; // Default value
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    resetLocation(); // Set default location on init
  }

  Future<void> resetLocation() async {
    // Reset location to default values
    currentPosition.value = null;
    locationMessage.value = "Belum diatur";
    address.value = "Belum diatur";
  }

  Future<void> getCurrentLocation() async {
    loading.value = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception("Location service is not enabled");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied forever");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      currentPosition.value = position;
      locationMessage.value =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address.value =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        address.value = "Alamat tidak ditemukan";
      }
    } catch (e) {
      locationMessage.value = "Gagal mendapatkan lokasi";
      address.value = "Gagal mendapatkan alamat";
    } finally {
      loading.value = false;
    }
  }

  Future<void> searchLocation(String locationName) async {
    if (locationName.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama lokasi tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    loading.value = true;

    try {
      List<Location> locations = await locationFromAddress(locationName);

      if (locations.isNotEmpty) {
        Location location = locations.first;

        currentPosition.value = Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );

        locationMessage.value =
            "Latitude: ${location.latitude}, Longitude: ${location.longitude}";

        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          address.value =
              "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        } else {
          address.value = "Alamat tidak ditemukan";
        }
      } else {
        Get.snackbar(
          'Error',
          'Lokasi tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mencari lokasi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  void openGoogleMaps() async {
    if (currentPosition.value != null) {
      final latitude = currentPosition.value!.latitude;
      final longitude = currentPosition.value!.longitude;
      final url =
          Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open Google Maps',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Location is not available yet',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
