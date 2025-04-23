import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finanpro_v2/controllers/auth_controller.dart';
import '../components/text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController _authController = Get.put(AuthController());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController firstLastNameController = TextEditingController();
  final TextEditingController secondLastNameController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime? birthDate;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "FinanPro",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 111, 183, 31),
      ),
      body: Obx(() {
        if (_authController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 111, 183, 31),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField("Primer Nombre", firstNameController),
                  buildTextField("Segundo Nombre", secondNameController),
                  buildTextField("Primer Apellido", firstLastNameController),
                  buildTextField("Segundo Apellido", secondLastNameController),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          "Fecha de Nacimiento",
                          birthDateController,
                          readOnly: false,
                          isNumeric: true,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            birthDate = pickedDate;
                            birthDateController.text =
                                "${pickedDate.toLocal()}".split(' ')[0];
                          }
                        },
                      ),
                    ],
                  ),
                  buildTextField("Cédula", idController, isNumeric: true),
                  buildTextField("Email", emailController),
                  buildTextField("Teléfono", phoneController, isNumeric: true),
                  buildTextField("Clave", passwordController, isNumeric: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      registrar(birthDate, context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 111, 183, 31),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Registrarse",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  void registrar(DateTime? birthDate, BuildContext context) {
    String firstName = firstNameController.text.trim();
    String secondName = secondNameController.text.trim();
    String firstLastName = firstLastNameController.text.trim();
    String secondLastName = secondLastNameController.text.trim();
    String documentNumber = idController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (firstName.isEmpty ||
        firstLastName.isEmpty ||
        secondLastName.isEmpty ||
        documentNumber.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        birthDate == null ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Los campos obligatorios no pueden estar vacíos."),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (password.length > 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("La contraseña debe ser de 6 dígitos"),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Aquí puedes agregar la lógica para enviar los datos al backend
    _authController.register(
      email,
      password,
      firstName,
      secondName,
      firstLastName,
      secondLastName,
      documentNumber,
      phone,
      birthDate!,
    );
  }
}
