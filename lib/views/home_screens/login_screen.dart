import 'package:finanpro_v2/views/home_screens/recover_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart'; // Para autenticación biométrica
import 'package:finanpro_v2/controllers/auth_controller.dart';
import 'package:finanpro_v2/views/components/keypad_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pin = "";
  final LocalAuthentication auth = LocalAuthentication();
  final AuthController _authController = Get.put(AuthController());
  final CedulaController cedulaController = Get.find();

  Future<void> _authenticate() async {
    final scaffoldMessenger = ScaffoldMessenger.of(
      context,
    ); // Obtener la referencia antes del método asíncrono
    try {
      if (await _authController.areCredentialsStored()) {
        bool authenticated = await auth.authenticate(
          localizedReason: "Escanea tu huella para ingresar",
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (authenticated) {
          await _authController.autoLogin();
        }
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error en autenticación biométrica: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onKeyPressed(String value) {
    if (value == "backspace") {
      setState(() {
        if (pin.isNotEmpty) {
          pin = pin.substring(0, pin.length - 1);
        }
      });
    } else if (value == "fingerprint") {
      _authenticate();
    } else {
      if (pin.length < 6) {
        setState(() {
          pin += value;
        });
        if (pin.length == 6) {
          _authController.login(cedulaController.cedula.value, pin);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 111, 183, 31),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 111, 183, 31),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_authController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ingrese su Clave...",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 35,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          index < pin.length ? "*" : "",
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ), // Ajusta el margen lateral
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      for (var i = 1; i <= 9; i++)
                        buildKeypadButton(
                          i.toString(),
                          (val) => _onKeyPressed(val),
                        ),
                      buildKeypadButton(
                        "fingerprint",
                        (val) => _onKeyPressed(val),
                      ),
                      buildKeypadButton("0", (val) => _onKeyPressed(val)),
                      buildKeypadButton(
                        "backspace",
                        (val) => _onKeyPressed(val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecoverPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "¿Olvidó su contraseña?",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class CedulaController extends GetxController {
  var cedula = ''.obs;
  final storage = GetStorage();

  void setCedula(String value) {
    cedula.value = value;
    storage.write('documentNumber', value);
  }

  void loadStoredCedula() {
    String? storedCedula = storage.read('documentNumber');
    if (storedCedula != null) {
      cedula.value = storedCedula;
    }
  }
}
