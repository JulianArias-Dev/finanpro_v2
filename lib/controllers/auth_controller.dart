import 'dart:io';
import 'package:finanpro_v2/views/start_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart'; // Importar GetStorage
import 'package:finanpro_v2/views/home_screen.dart';
import 'package:finanpro_v2/services/auth_service.dart';
import 'package:finanpro_v2/models/user_model.dart';

class AuthController extends GetxController {
  var imageFile =
      Rxn<File>(); // Variable para almacenar la imagen seleccionada en móvil
  var imageWebFile =
      Rxn<Uint8List>(); // Variable para almacenar la imagen seleccionada en web
  final AuthService _firebaseService = AuthService();
  var isLoading = false.obs; // Observa si se está cargando una operación
  var user = Rxn<Usuario>(); // Observa el estado del usuario
  final storage =
      GetStorage()
          .obs; // Crear una instancia de GetStorage para almacenar las credenciales

  // Método para registrar el usuario y guardar datos en Firestore
  Future<void> register(
    String email,
    String password,
    String firstName,
    String secondName,
    String firstLastName,
    String secondLastName,
    String documentNumber,
    String phone,
    DateTime birthDate,
  ) async {
    try {
      isLoading.value = true;
      Usuario? newUser = await _firebaseService.registerWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        secondName: secondName,
        firstLastName: firstLastName,
        secondLastName: secondLastName,
        documentNumber: documentNumber,
        phone: phone,
        birthDate: birthDate,
      );
      if (newUser != null) {
        user.value = newUser; // Usuario registrado exitosamente
        await _saveCredentials(email, password); // Guardar credenciales
        Get.offAll(() => HomeScreen()); // Redirigir a la vista principal
      } else {
        Get.snackbar("Error", "No se pudo registrar el usuario");
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error durante el registro");
    } finally {
      isLoading.value = false;
    }
  }

  // Método para iniciar sesión
  Future<void> login(String documentNumber, String password) async {
    try {
      isLoading.value = true;
      Usuario? loggedInUser = await _firebaseService.loginWithDocument(
        documentNumber,
        password,
      );
      if (loggedInUser != null) {
        user.value = loggedInUser;
        await _saveCredentials(documentNumber, password);
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar("Error", "No se pudo iniciar sesión");
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error durante el inicio de sesión");
    } finally {
      isLoading.value = false;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseService.signOut();
    user.value = null; // Usuario ha cerrado sesión
    Get.snackbar("Sesión cerrada", "Hasta pronto");
    Get.offAll(() => StartScreen()); // Redirigir a la vista de login
  }

  // Guardar las credenciales de usuario usando GetStorage
  Future<void> _saveCredentials(String documentNumber, String password) async {
    storage.value.write('documentNumber', documentNumber);
    storage.value.write('password', password);
  }

  // Intentar login automático
  Future<void> autoLogin() async {
    String? documentNumber = storage.value.read('documentNumber');
    String? password = storage.value.read('password');

    if (documentNumber != null && password != null) {
      await login(documentNumber, password);
    }
  }

  // Eliminar las credenciales guardadas
  /* Future<void> _clearCredentials() async {
    storage.value.remove('documentNumber');
    storage.value.remove('password');
  } */

  Future<bool> areCredentialsStored() async {
    String? documentNumber = storage.value.read('documentNumber');
    String? password = storage.value.read('password');
    return documentNumber != null && password != null;
  }
}
