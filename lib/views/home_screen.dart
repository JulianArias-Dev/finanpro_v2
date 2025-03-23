import 'package:finanpro_v2/views/anualidades_screen.dart';
import 'package:finanpro_v2/views/interes_compuesto_screen.dart';
import 'package:finanpro_v2/views/interes_simple_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finanpro_v2/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = authController.user.value;
      if (user == null) {
        return Center(
          child: CircularProgressIndicator(),
        ); // Muestra carga si el usuario es null
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "FinanPro",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, size: 25, color: Colors.white),
              onPressed: () {
                authController.signOut(); // Llamar al método de cerrar sesión
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 111, 183, 31),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 111, 183, 31),
                child: Column(
                  children: [
                    const SizedBox(height: 35),
                    Text(
                      "Bienvenido ${user.firstName} ${user.firstLastName}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Saldo",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      "\$ ${user.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Educación Financiera",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildOptionButton(
                            "Interés Simple",
                            context,
                            const InterestScreen(),
                          ),
                          _buildOptionButton(
                            "Interés Compuesto",
                            context,
                            const InteresCompuestoScreen(),
                          ),
                          _buildOptionButton(
                            "Anualidades",
                            context,
                            const AnualidadesScreen(),
                          ),
                          _buildOptionButton("Gradientes", context, null),
                          _buildOptionButton(
                            "Sistemas de Amortización",
                            context,
                            null,
                          ),
                          _buildOptionButton(
                            "Sistemas de Capitalización",
                            context,
                            null,
                          ),
                          _buildOptionButton("TIR", context, null),
                          _buildOptionButton("UVR", context, null),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gestión de Préstamos",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildOptionButton("Nuevo Préstamo", context, null),
                          _buildOptionButton(
                            "Préstamos Vigentes",
                            context,
                            null,
                          ),
                          _buildOptionButton("Pagar Préstamo", context, null),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOptionButton(String title, BuildContext context, Widget? page) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ElevatedButton(
        onPressed:
            page != null
                ? () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                )
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(255, 111, 183, 31),
              width: 3,
            ),
          ),
          minimumSize: const Size(130, 95),
        ),
        child: SizedBox(
          width: 95, // Set a fixed width to wrap text
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
