import 'package:finanpro_v2/views/screens/amortizacion_screen.dart';
import 'package:finanpro_v2/views/screens/anualidades_screen.dart';
import 'package:finanpro_v2/views/screens/capitalizacion_screen.dart';
import 'package:finanpro_v2/views/screens/gradientes_screen.dart';
import 'package:finanpro_v2/views/screens/interes_compuesto_screen.dart';
import 'package:finanpro_v2/views/components/theme_controller.dart';
import 'package:finanpro_v2/views/screens/interes_simple_screen.dart';
import 'package:finanpro_v2/views/screens/series_variables_screen.dart';
import 'package:finanpro_v2/views/screens/tir_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 111, 183, 31)),
            child: Text(
              'Menú de Navegación',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Educacion Financiera'),
            children: [
              _ListItem(
                Icons.arrow_right,
                'Interés Simple',
                context,
                const InteresSimpleScreen(),
              ),
              _ListItem(
                Icons.arrow_right,
                'Interés Compuesto',
                context,
                const InteresCompuestoScreen(),
              ),
              _ListItem(
                Icons.arrow_right,
                'Anualidades',
                context,
                const AnualidadesScreen(),
              ),
              _ListItem(
                Icons.arrow_right,
                'Gradientes',
                context,
                const GradientesScreen(),
              ),
              _ListItem(
                Icons.arrow_right,
                'Series Variables',
                context,
                const SeriesVariablesScreen(),
              ),
              _ListItem(
                Icons.arrow_right,
                'Sistemas de Amortización',
                context,
                const AmortizacionScreen(),
              ),
              _ListItem(
                Icons.arrow_right,
                'Sistemas de Capitalización',
                context,
                const CapitalizacionScreen(),
              ),
              _ListItem(
                Icons.arrow_right,
                'Tasa de Interes de Retorno - TIR',
                context,
                const TirScreen(),
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.work),
            title: const Text('Gestión Financiera'),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_right),
                title: const Text('Nuevo Préstamo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_right),
                title: const Text('Prestamos Vigentes'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_right),
                title: const Text('Pagar Préstamo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Aplicación'),
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Modo Oscuro'),
                onTap: () {
                  Get.find<ThemeController>().setDarkMode();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Modo Claro'),
                onTap: () {
                  Get.find<ThemeController>().setLightMode();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 50),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi cuenta'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

Widget _ListItem(
  IconData icon,
  String title,
  BuildContext context,
  Widget page,
) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
  );
}
