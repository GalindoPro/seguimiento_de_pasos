import 'package:flutter/material.dart';

void main() {
  runApp(PasoApp()); // Inicia la aplicación
}

// Widget principal de la aplicación
class PasoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Pasos',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema de la app
      ),
      home: PasoHomePage(), // Página principal
    );
  }
}

// Página principal con estado (porque los valores cambian)
class PasoHomePage extends StatefulWidget {
  @override
  _PasoHomePageState createState() => _PasoHomePageState();
}

class _PasoHomePageState extends State<PasoHomePage> {
  int pasos = 0; // Contador de pasos
  int meta = 1000; // Meta inicial de pasos
  final TextEditingController _metaController =
      TextEditingController(); // Controlador para el campo de texto

  // Función para actualizar la meta cuando el usuario ingresa un número
  void _actualizarMeta(String valor) {
    setState(() {
      meta =
          int.tryParse(valor) ??
          1000; // Convierte el texto a número, o usa 1000 por defecto
    });
  }

  // Función para sumar pasos y verificar si se cumplió la meta
  void _sumarPaso() {
    setState(() {
      pasos++;
      _verificarMeta(); // Verifica si se alcanzó la meta
    });
  }

  // Función para restar pasos (evita valores negativos)
  void _restarPaso() {
    setState(() {
      if (pasos > 0) pasos--;
    });
  }

  // Función para reiniciar el contador de pasos
  void _reiniciar() {
    setState(() {
      pasos = 0;
    });
  }

  // Verifica si se alcanzó la meta y muestra un mensaje emergente
  void _verificarMeta() {
    if (pasos >= meta) {
      Future.delayed(Duration(milliseconds: 200), () {
        // Espera un poco antes de mostrar el mensaje
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('¡Felicidades!'),
              content: Text('Meta de pasos alcanzada 🎉'),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(), // Cierra el mensaje
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  // Calcula el progreso en porcentaje (para la barra de progreso)
  double get progreso => pasos / meta;

  // Define el color de la barra de progreso según el avance
  Color get colorBarra {
    if (progreso >= 1) return Colors.green; // Verde si alcanzó o superó la meta
    if (progreso >= 0.5) return Colors.orange; // Naranja si está en la mitad
    return Colors.red; // Rojo si está por debajo del 50%
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contador de Pasos')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Campo de texto para ingresar la meta de pasos
            TextField(
              controller: _metaController,
              keyboardType: TextInputType.number, // Solo permite números
              decoration: InputDecoration(
                labelText: 'Ingresá tu meta de pasos',
                border: OutlineInputBorder(),
              ),
              onSubmitted:
                  _actualizarMeta, // Llama a la función cuando el usuario presiona "Enter"
            ),
            SizedBox(height: 20),

            // Muestra los pasos actuales y la meta
            Text(
              'Pasos actuales: $pasos / $meta',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            // Barra de progreso que cambia de color según el avance
            LinearProgressIndicator(
              value:
                  progreso > 1
                      ? 1
                      : progreso, // Si el progreso es mayor a 100%, se queda en 100%
              color: colorBarra, // Color dinámico según el progreso
              backgroundColor: Colors.grey[300], // Fondo gris
              minHeight: 20, // Altura de la barra
            ),
            SizedBox(height: 30),

            // Botones para sumar y restar pasos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _restarPaso, child: Text('-1 Paso')),
                ElevatedButton(onPressed: _sumarPaso, child: Text('+1 Paso')),
              ],
            ),

            Spacer(), // Empuja el botón de reinicio hacia abajo
            // Botón para reiniciar los pasos
            ElevatedButton.icon(
              onPressed: _reiniciar,
              icon: Icon(Icons.refresh),
              label: Text('Reiniciar Día'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
