import 'package:flutter/material.dart';
import 'package:BodyBuilding/app/modules/login/views/login_view.dart';

import 'package:get/get.dart';

import 'package:BodyBuilding/app/modules/splash_screen/controllers/splash_screen_controller.dart';

class SplashScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigasi otomatis ke login setelah 3 detik
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => LoginView()); // Navigasi ke halaman login
    });

    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Break Limits\nBuild Strength',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nosifer',
                  fontSize: 28,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 3),
                child: Image.asset(
                  'assets/Sign.png', // Pastikan path benar
                  height: 200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
