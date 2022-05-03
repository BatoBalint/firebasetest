import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Jelszó',
                ),
              ),
              TextField(
                controller: passwordAgainController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Jelszó megint',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton.icon(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: const Size.fromHeight(50)),
                  icon: const Icon(
                    Icons.bookmark_add,
                    size: 32,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Regisztráció',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: 'Vissza a ',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      TextSpan(
                        text: 'bejelentkezéshez',
                        style: const TextStyle(
                          color: Colors.blue,
                          letterSpacing: 1,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = bactToLogin,
                      ),
                    ]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void bactToLogin() {
    Navigator.pop(context);
  }

  Future register() async {
    if (passwordController.text.trim() != passwordAgainController.text.trim()) {
      alertToUser('A jelszavak nem egyeznek');
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        alertToUser('Sikeres regisztracio');
        Navigator.pop(context);
      } on Exception catch (e) {
        String message = e.toString().split('/')[1].split(']')[1];
        alertToUser(message);
      }
    }
  }

  void alertToUser(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ));
  }
}
