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
    String? secondName,
    required String firstLastName,
    required String secondLastName,
    required String documentNumber,
    required String phone,
    required DateTime birthDate,
  }) async {
    try {
      // Verificar si el email ya existe en Firebase Auth
      final existingEmailUsers = await _auth.fetchSignInMethodsForEmail(email);
      if (existingEmailUsers.isNotEmpty) {
        throw StateError('El correo ya está registrado.');
      }

      // Verificar si documentNumber ya existe en Firestore
      final docQuery =
          await _firestore
              .collection('users')
              .where('documentNumber', isEqualTo: documentNumber)
              .limit(1)
              .get();
      if (docQuery.docs.isNotEmpty) {
        throw StateError('El número de documento ya está registrado.');
      }

      // Verificar si phone ya existe en Firestore
      final phoneQuery =
          await _firestore
              .collection('users')
              .where('phone', isEqualTo: phone)
              .limit(1)
              .get();
      if (phoneQuery.docs.isNotEmpty) {
        throw StateError('El número de teléfono ya está registrado.');
      }

      // Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

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

        return Usuario(
          id: user.uid,
          firstName: firstName,
          secondName: secondName ?? '',
          firstLastName: firstLastName,
          secondLastName: secondLastName,
          documentNumber: documentNumber,
          email: email,
          phone: phone,
          birthDate: birthDate,
          amount: 0.0,
        );
      }

      return null;
    } catch (e) {
      throw StateError("Error en el registro: $e");
    }
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
        throw StateError("No se encontró un usuario con esa cédula.");
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
        throw StateError("Error al iniciar sesión.");
      }

      // 4. Obtener los datos del usuario desde Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw StateError("No se encontraron datos del usuario en Firestore.");
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw StateError('Contraseña incorrecta.');
      } else if (e.code == 'user-not-found') {
        throw StateError('No se encontró un usuario con ese correo.');
      } else {
        throw StateError('Error de autenticación valide sus credenciales.');
      }
    } catch (e) {
      throw StateError("Error en el inicio de sesión: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw UnsupportedError("Error al cerrar sesión: $e");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw StateError('Error al enviar el correo de recuperación: $e');
    }
  }

  // Obtener usuario actual
  User? get currentUser {
    return _auth.currentUser;
  }
}
