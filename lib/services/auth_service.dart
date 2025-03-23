//import 'dart:io';
import 'package:finanpro_v2/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instancia de Firestore
  //final FirebaseStorage _storage = FirebaseStorage.instance;

  // Método para registrar un usuario con correo y contraseña
  Future<Usuario?> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String secondName,
    required String firstLastName,
    required String secondLastName,
    required String documentNumber,
    required String phone,
    required DateTime birthDate,
  }) async {
    /*   try { */
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    // Si el usuario se crea correctamente, guarda los datos en Firestore
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'secondName': secondName,
        'firstLastName': firstLastName,
        'secondLastName': secondLastName,
        'documentNumber': documentNumber,
        'email': email,
        'phone': phone,
        'birthDate': Timestamp.fromDate(birthDate),
        'amount': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Crea una instancia de Usuario usando el modelo
      Usuario usuario = Usuario(
        id: user.uid,
        firstName: firstName,
        secondName: secondName,
        firstLastName: firstLastName,
        secondLastName: secondLastName,
        documentNumber: documentNumber,
        email: email,
        phone: phone,
        birthDate: birthDate,
        amount: 0.0,
      );

      return usuario; // Retorna el objeto Usuario
    }

    return null;
    /* } catch (e) {
      throw StateError("Error en el registro: $e");
    } */
  }

  Future<Usuario?> loginWithDocument(
    String documentNumber,
    String password,
  ) async {
    try {
      // 1. Buscar el usuario en Firestore por su número de documento
      QuerySnapshot query =
          await _firestore
              .collection('users')
              .where('documentNumber', isEqualTo: documentNumber)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        throw StateError("Error: No se encontró un usuario con esa cédula.");
      }

      // 2. Obtener el email asociado al número de documento
      Map<String, dynamic> userData =
          query.docs.first.data() as Map<String, dynamic>;
      String email = userData['email'];

      // 3. Iniciar sesión con Firebase Auth usando el email y la contraseña
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        throw StateError("Error: Error al iniciar sesion 11.");
      }

      // 4. Obtener los datos del usuario desde Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw StateError(
          "Error: No se encontraron datos del usuario en Firestore.",
        );
      }

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      // 5. Crear y retornar el objeto Usuario
      return Usuario(
        id: user.uid,
        firstName: data['firstName'],
        secondName: data.containsKey('secondName') ? data['secondName'] : '',
        firstLastName: data['firstLastName'],
        secondLastName: data['secondLastName'],
        documentNumber: data['documentNumber'],
        email: data['email'],
        phone: data['phone'],
        birthDate: (data['birthDate'] as Timestamp).toDate(),
        amount: data.containsKey('amount') ? data['amount'] : 0,
      );
    } catch (e) {
      throw UnsupportedError("Error en el inicio de sesión: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw UnsupportedError("Error al cerrar sesión: $e");
    }
  }

  // Obtener usuario actual
  User? get currentUser {
    return _auth.currentUser;
  }
}
