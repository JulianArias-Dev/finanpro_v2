import 'package:flutter/material.dart';
import 'package:finanpro_v2/controllers/capitalizacion_controller.dart';
import 'package:finanpro_v2/views/components/text_field.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';

class CapitalizacionScreen extends StatefulWidget {
  const CapitalizacionScreen({super.key});

  @override
  State<CapitalizacionScreen> createState() => _CapitalizacionScreenState();
}

class _CapitalizacionScreenState extends State<CapitalizacionScreen> {
  final CapitalizacionController controller = CapitalizacionController();

  String tipoCapitalizacion = 'Individual compuesta';
  Map<String, String> tipos = {
    'Individual compuesta': 'CapInicial',
    'Individual con aportes': 'CapPeriodica',
    'Colectiva': 'CapColectiva',
  };
  final TextEditingController capitalInicialController =
      TextEditingController();
  final TextEditingController tasaController = TextEditingController();
  final TextEditingController periodosAnualesController =
      TextEditingController();
  final TextEditingController aniosController = TextEditingController();

  final TextEditingController aportePeriodicoController =
      TextEditingController();
  final TextEditingController numeroAportesController = TextEditingController();

  List<TextEditingController> aportesColectivos = [TextEditingController()];
  List<TextEditingController> tiemposColectivos = [TextEditingController()];
  final TextEditingController tasaColectivaController = TextEditingController();

  String resultado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capitalización'),
        backgroundColor: const Color.fromARGB(255, 111, 183, 31),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sistemas de capitalización",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "La capitalización es el proceso mediante el cual se acumulan intereses sobre un capital inicial, generando un crecimiento exponencial del mismo a lo largo del tiempo.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height *
                    0.3, // 30% de alto pantalla
              ),
              child: Image.asset(
                'assets/formulas/${tipos[tipoCapitalizacion]}.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: tipoCapitalizacion,
              decoration: const InputDecoration(
                labelText: "Tipo de capitalización",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Individual compuesta',
                  child: Text('Individual compuesta'),
                ),
                DropdownMenuItem(
                  value: 'Individual con aportes',
                  child: Text('Individual con aportes'),
                ),
                DropdownMenuItem(value: 'Colectiva', child: Text('Colectiva')),
              ],
              onChanged: (value) {
                setState(() {
                  tipoCapitalizacion = value!;
                  resultado = '';
                });
              },
            ),
            const SizedBox(height: 20),
            if (tipoCapitalizacion == 'Individual compuesta') ...[
              buildTextField(
                'Capital inicial (\$)',
                capitalInicialController,
                isNumeric: true,
                isMoney: true,
              ),
              buildTextField(
                'Tasa de interés (%)',
                tasaController,
                isNumeric: true,
              ),
              buildTextField(
                'Número de periodos por año',
                periodosAnualesController,
                isNumeric: true,
              ),
              buildTextField(
                'Número de años',
                aniosController,
                isNumeric: true,
              ),
            ] else if (tipoCapitalizacion == 'Individual con aportes') ...[
              buildTextField(
                'Aporte periódico (\$)',
                aportePeriodicoController,
                isNumeric: true,
                isMoney: true,
              ),
              buildTextField(
                'Tasa de interés (%)',
                tasaController,
                isNumeric: true,
              ),
              buildTextField(
                'Número de aportes',
                numeroAportesController,
                isNumeric: true,
              ),
            ] else if (tipoCapitalizacion == 'Colectiva') ...[
              const Text(
                "Aportes y tiempos:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: aportesColectivos.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          'Aporte \$',
                          aportesColectivos[index],
                          isNumeric: true,
                          isMoney: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildTextField(
                          'Tiempo',
                          tiemposColectivos[index],
                          isNumeric: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        aportesColectivos.add(TextEditingController());
                        tiemposColectivos.add(TextEditingController());
                      });
                    },
                    child: const Text("Agregar"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (aportesColectivos.length > 1) {
                          aportesColectivos.removeLast();
                          tiemposColectivos.removeLast();
                        }
                      });
                    },
                    child: const Text("Eliminar"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildTextField(
                'Tasa de interés (%)',
                tasaColectivaController,
                isNumeric: true,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 111, 183, 31),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: calcularResultado,
              child: const Text("Calcular"),
            ),
            const SizedBox(height: 20),
            Text(
              resultado,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void calcularResultado() {
    try {
      double res = 0;

      if (tipoCapitalizacion == 'Individual compuesta') {
        final p = parseCurrency(capitalInicialController.text);
        final r = double.parse(tasaController.text) / 100;
        final n = int.parse(periodosAnualesController.text);
        final t = int.parse(aniosController.text);
        res = controller.capitalizacionIndividualCompuesta(p, r, n, t);
      } else if (tipoCapitalizacion == 'Individual con aportes') {
        final p = parseCurrency(aportePeriodicoController.text);
        final r = double.parse(tasaController.text) / 100;
        final n = int.parse(numeroAportesController.text);
        res = controller.capitalizacionIndividualConAportes(p, r, n);
      } else if (tipoCapitalizacion == 'Colectiva') {
        final aportes =
            aportesColectivos.map((e) => parseCurrency(e.text)).toList();
        final tiempos =
            tiemposColectivos.map((e) => int.parse(e.text)).toList();
        final tasa = double.parse(tasaColectivaController.text) / 100;
        res = controller.capitalizacionColectiva(aportes, tiempos, tasa);
      }

      setState(() {
        resultado = 'Valor Futuro: \$${formatCurrency(res)}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}
