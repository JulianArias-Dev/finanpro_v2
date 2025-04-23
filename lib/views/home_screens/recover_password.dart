import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finanpro_v2/controllers/auth_controller.dart';
import 'package:finanpro_v2/views/components/text_field.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  void _recoverPassword() {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar(
        'Error',
        'Ingrese un correo electrónico válido',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _authController.resetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 183, 31),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 111, 183, 31),
        elevation: 0,
        title: const Text(
          'Recuperar Contraseña',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ingrese su correo electrónico",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Correo electrónico',
              emailController,
              hintText: 'usuario@ejemplo.com',
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _recoverPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 111, 183, 31),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.lock_reset),
              label: const Text(
                'Recuperar contraseña',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
