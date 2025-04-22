import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/screens/amortizacion_screen.dart';
import 'package:finanpro_v2/views/screens/anualidades_screen.dart';
import 'package:finanpro_v2/views/screens/capitalizacion_screen.dart';
import 'package:finanpro_v2/views/screens/gradientes_screen.dart';
import 'package:finanpro_v2/views/screens/interes_compuesto_screen.dart';
import 'package:finanpro_v2/views/screens/interes_simple_screen.dart';
import 'package:finanpro_v2/views/screens/series_variables_screen.dart';
import 'package:finanpro_v2/views/screens/tir_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finanpro_v2/controllers/auth_controller.dart';
import 'package:finanpro_v2/views/components/my_drawer.dart';
import 'package:finanpro_v2/views/components/option_button.dart';

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
              icon: Icon(Icons.exit_to_app, size: 25, color: Colors.white),
              onPressed: () {
                authController.exitApp(); // Llamar al método de cerrar sesión
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 111, 183, 31),
        ),
        drawer: MyDrawer(),
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
                      "Bienvenido, ${user.firstName} ${user.firstLastName}",
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
                      "\$ ${formatCurrency(user.amount)}",
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
                  color: Theme.of(context).colorScheme.surface,
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
                          buildOptionButton(
                            "Interés Simple",
                            context,
                            const InteresSimpleScreen(),
                          ),
                          buildOptionButton(
                            "Interés Compuesto",
                            context,
                            const InteresCompuestoScreen(),
                          ),
                          buildOptionButton(
                            "Anualidades",
                            context,
                            const AnualidadesScreen(),
                          ),
                          buildOptionButton(
                            "Gradientes",
                            context,
                            const GradientesScreen(),
                          ),
                          buildOptionButton(
                            "Series Variables",
                            context,
                            const SeriesVariablesScreen(),
                          ),
                          buildOptionButton(
                            "Sistemas de Amortización",
                            context,
                            const AmortizacionScreen(),
                          ),
                          buildOptionButton(
                            "Sistemas de Capitalización",
                            context,
                            const CapitalizacionScreen(),
                          ),
                          buildOptionButton("TIR", context, const TirScreen()),
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
                  color: Theme.of(context).colorScheme.surface,
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
                          buildOptionButton("Nuevo Préstamo", context, null),
                          buildOptionButton(
                            "Préstamos Vigentes",
                            context,
                            null,
                          ),
                          buildOptionButton("Pagar Préstamo", context, null),
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
}
