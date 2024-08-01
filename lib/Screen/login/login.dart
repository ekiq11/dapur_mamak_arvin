// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:clone_state_management/Screen/landing.dart';
import 'package:clone_state_management/api/api.dart';
import 'package:clone_state_management/widget/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool visible = false;
  bool passwordVisible = true;
  ceklogin() async {
    // Menampilkan loader
    // Loader.show(
    //   context,
    //   isAppbarOverlay: true,
    //   isBottomBarOverlay: false,
    //   progressIndicator: const CircularProgressIndicator(),
    //   themeData: Theme.of(context).copyWith(
    //       colorScheme:
    //           ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
    //   overlayColor: const Color(0x99E8EAF6),
    // );

    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        final res = await http.post(Uri.parse(BaseURL.login), body: {
          "username": userNameController.text,
          "password": passwordController.text,
        });

        if (res.statusCode == 200) {
          var responseJson = json.decode(res.body);

          // Periksa apakah respons memiliki error false
          if (responseJson['error'] == 'false') {
            // Ambil data admin dari respons
            var adminData = responseJson['data'][0];

            // Simpan informasi admin ke SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            // prefs.setString('idUser', adminData['id_admin']);
            prefs.setString('username', adminData['username']);

            // Navigasi ke halaman selanjutnya (LandingPage)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const LandingPage(),
              ),
            );
            print(adminData);
          } else {
            // Tampilkan pesan error karena username atau password salah
            _showErrorDialog('Username dan password salah');
          }
        } else {
          // Tampilkan pesan error karena terjadi kesalahan saat melakukan request
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Error"),
              content: Text("Username dan Password Salah"),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print("Error: $e");
        // Menutup loader
        Loader.hide();

        // Menampilkan dialog jika terjadi error
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Error"),
            content: Text("Chek koneksi internat anda!"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Menutup loader
      Loader.hide();

      // Menampilkan dialog jika username atau password kosong
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Login Gagal"),
          content: Text("Username dan password tidak boleh kosong."),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Gagal'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Loader.hide();
    print("Called dispose");
    super.dispose();
  }

  // Future<bool> _onWillPop() async {
  //   return false; //<-- SEE HERE
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: kblue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              "Selamat Datang,",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Silahkan login untuk masuk!",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Image(image: NetworkImage("assets/icon/logo3.png")),
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: Icon(
                        passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                    labelText: "Password",
                    labelStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ceklogin,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(width: 15.0),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color: Colors.white,
                        )
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Image(
                  image: AssetImage('assets/icon/logo3.png'),
                  height: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Dapur Mamak Arvin")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
