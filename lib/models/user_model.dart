import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String id;
  String firstName;
  String secondName;
  String firstLastName;
  String secondLastName;
  String documentNumber;
  String email;
  String phone; // Opcional
  DateTime birthDate; // Opcional
  double amount;

  // Constructor
  Usuario({
    required this.id,
    required this.firstName,
    this.secondName = '',
    required this.firstLastName,
    required this.secondLastName,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.birthDate,
    this.amount = 0,
  });

  // Método para convertir un documento de Firestore en una instancia de Usuario
  factory Usuario.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id, // ID del documento
      firstName: data['fistName'],
      secondName: data['secondName'],
      firstLastName: data['firstLastName'],
      secondLastName: data['secondLastName'],
      documentNumber: data['documentNumber'],
      email: data['email'] ?? '',
      phone: data['phone'], // Puede ser nulo
      // Verificamos si 'birthDate' no es nulo y lo convertimos a DateTime
      birthDate:
          (data['birthDate'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      amount: data['amount']?.toDouble() ?? 0.0,
    );
  }

  // Método para convertir un objeto Usuario a Map (para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'secondName': secondName,
      'firstLastName': firstLastName,
      'secondLastName': secondLastName,
      'documentNumber': documentNumber,
      'email': email,
      'phone': phone,
      'birthDate': Timestamp.fromDate(birthDate),
      'amount': amount,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
