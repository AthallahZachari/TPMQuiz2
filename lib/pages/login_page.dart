import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tpm_kelompok/pages/home_page.dart';
// import 'home_screen.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';
  bool isLoginSuccess = false;
  final box = GetStorage();
  final checkLogin = GetStorage('checkLogin');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                              color: Color(0xFF00458B)),
                        ),
                        Text(
                          'Welcome back, glad to see you again!',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  _username(),
                  _password(),
                  _loginButton(context),
                  _signupButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _username() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person_outline_rounded),
          hintText: 'Username',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
        ),
        onChanged: (value) {
          username = value;
        },
      ),
    );
  }

  Widget _password() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock_outline_rounded),
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
        ),
        onChanged: (value) {
          password = value;
        },
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () {
            String text = '';
            String originalUsername = '';
            if (box.hasData(username.toLowerCase()) &&
                box.read(username.toLowerCase())[0] ==
                    _hashPassword(password)) {
              setState(() {
                isLoginSuccess = true;
                text = 'Login Success!';
                originalUsername = box.read(username.toLowerCase())[1];
              });
            } else {
              setState(() {
                isLoginSuccess = false;
                text = 'Wrong username or password!';
              });
            }
            SnackBar snackbar = SnackBar(content: Text(text));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            if (isLoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    checkLogin.write('isLoggedIn', true);
                    checkLogin.write('username', originalUsername);
                    return const HomePage();
                  },
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00458B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(15),
          ),
          child: const Text('Login'),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const SignupPage();
            },
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(color: Colors.grey[600]),
          ),
          const Text(
            "Sign Up",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF00458B),
            ),
          )
        ],
      ),
    );
  }

  String _hashPassword(String password) {
    List<int> bytes = utf8.encode(password);
    Digest sha256Result = sha256.convert(bytes);
    return sha256Result.toString();
  }
}
