import 'package:flutter/material.dart';
import 'package:tpm_kelompok/pages/home_page.dart';
import 'package:tpm_kelompok/pages/login_page.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  await GetStorage.init('checkLogin');
  await GetStorage.init('favorite');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final checkLogin = GetStorage('checkLogin');
    bool isLoggedIn = checkLogin.read('isLoggedIn') ?? false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomePage() : const LoginPage(),
      theme: ThemeData(fontFamily: 'Poppins'),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(fontFamily: 'Poppins'),
    //   home: const HomePage(),
    // );
  }
}
