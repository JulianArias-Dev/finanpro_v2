import 'dart:io';
import 'package:finanpro_v2/views/home_screens/start_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart'; // Importar GetStorage
import 'package:finanpro_v2/views/home_screens/home_screen.dart';
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
    final validationMessage = validateRegistrationData(
      email: email,
      password: password,
      documentNumber: documentNumber,
      phone: phone,
      birthDate: birthDate,
    );

    if (validationMessage != null) {
      Get.snackbar("Validación", validationMessage);
      return;
    }
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
        await _saveCredentials(
          documentNumber,
          password,
        ); // Guardar credenciales
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
      Get.snackbar(
        "Error",
        e is StateError ? e.message : "Ocurrió un error inesperado",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Método para recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _firebaseService.sendPasswordResetEmail(email);
      Get.snackbar('Correo enviado', 'Revisa tu bandeja de entrada');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo enviar el correo de recuperación');
    } finally {
      isLoading.value = false;
    }
  }

  // Método salir de la aplicación
  Future<void> exitApp() async {
    await _firebaseService.signOut();
    user.value = null; // Usuario ha cerrado sesión
    Get.snackbar("Sesión cerrada", "Hasta pronto");
    Get.offAll(() => StartScreen()); // Redirigir a la vista de login
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseService.signOut();
    user.value = null; // Usuario ha cerrado sesión
    Get.snackbar("Sesión cerrada", "Hasta pronto");
    await _clearCredentials(); // Limpiar credenciales almacenadas
    Get.offAll(() => StartScreen()); // Redirigir a la vista de login
  }

  // Guardar las credenciales de usuario usando GetStorage
  Future<void> _saveCredentials(String documentNumber, String password) async {
    storage.value.write('documentNumber', documentNumber);
    storage.value.write('password', password);
  }

  // Refrescar Usuario
  Future<void> refreshUser() async {
    if (user.value != null) {
      try {
        isLoading.value = true;
        Usuario? refreshedUser = await _firebaseService.refreshUserData();
        if (refreshedUser != null) {
          user.value = refreshedUser; // Actualizar el usuario
        } else {
          Get.snackbar("Error", "No se pudo actualizar el usuario");
        }
      } catch (e) {
        Get.snackbar("Error", "Ocurrió un error al refrescar el usuario");
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Intentar login automático
  Future<void> autoLogin() async {
    String? documentNumber = storage.value.read('documentNumber');
    String? password = storage.value.read('password');

    if (documentNumber != null && password != null) {
      await login(documentNumber, password);
    }
  }

  //Eliminar las credenciales guardadas
  Future<void> _clearCredentials() async {
    storage.value.remove('documentNumber');
    storage.value.remove('password');
  }

  Future<bool> areCredentialsStored() async {
    String? documentNumber = storage.value.read('documentNumber');
    String? password = storage.value.read('password');
    return documentNumber != null && password != null;
  }

  String? validateRegistrationData({
    required String email,
    required String password,
    required String documentNumber,
    required String phone,
    required DateTime birthDate,
  }) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    final passwordRegex = RegExp(r'^\d{6,}$');
    final documentRegex = RegExp(r'^\d{8,10}$');
    final phoneRegex = RegExp(r'^3\d{9}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Correo electrónico inválido.';
    }

    if (!passwordRegex.hasMatch(password)) {
      return 'La contraseña debe ser numérica y tener al menos 6 dígitos.';
    }

    if (!documentRegex.hasMatch(documentNumber)) {
      return 'Número de documento inválido. Debe tener entre 8 y 10 dígitos.';
    }

    if (!phoneRegex.hasMatch(phone)) {
      return 'Número de teléfono inválido. Debe comenzar con 3 y tener 10 dígitos.';
    }

    int age = DateTime.now().difference(birthDate).inDays ~/ 365;
    if (age < 15) {
      return 'Debes tener al menos 15 años para registrarte.';
    }

    return null; // Todo es válido
  }
}
