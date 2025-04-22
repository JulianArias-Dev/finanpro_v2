import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'views/start_screen.dart';
import 'views/components/theme_controller.dart';
import 'package:finanpro_v2/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init(); // Inicializar almacenamiento local

  Get.put(AuthController());
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(), // Modo claro
        darkTheme: ThemeData.dark(), // Modo oscuro
        themeMode: themeController.themeMode.value, // Controlado por GetX
        home: StartScreen(),
      ),
    );
  }
}
