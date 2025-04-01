import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// 📌 Controlador para manejar el tema con GetX y GetStorage
class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    bool isDarkMode = _storage.read<bool>('isDarkMode') ?? false;
    themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void setDarkMode() {
    themeMode.value = ThemeMode.dark;
    _storage.write('isDarkMode', true);
    Get.changeThemeMode(ThemeMode.dark);
  }

  void setLightMode() {
    themeMode.value = ThemeMode.light;
    _storage.write('isDarkMode', false);
    Get.changeThemeMode(ThemeMode.light);
  }
}
