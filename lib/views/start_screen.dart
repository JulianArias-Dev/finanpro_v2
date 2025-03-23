import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import './register_screen.dart';

class StartScreen extends StatelessWidget {
  StartScreen({super.key}) {
    cedulaController.loadStoredCedula();
    textController.text = cedulaController.cedula.value;
  }

  final CedulaController cedulaController = Get.put(CedulaController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 111, 183, 31),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "FinanPro",
                style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "powered by",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 5),
              const Text(
                "Universidad Popular del Cesar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 150),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Cédula",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (textController.text.trim().length != 8 &&
                      textController.text.trim().length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("La cédula debe tener 8 o 10 dígitos"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  cedulaController.setCedula(textController.text);
                  Get.to(() => const LoginScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 248, 221, 32),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 133,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Ingresar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => RegisterScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(0, 183, 183, 183),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 120,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Registrarse",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
