import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  // Cargar el archivo de variables de entorno.
  await dotenv.load(fileName: ".env");

  // Al mover la craeción del Theme de la app (que es un objeto MaterialApp)
  // se evita que este sea creado cada vez que se guardan cambios, lo que ahorra
  // recursos.
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: const InicioPage(),
    ),
  );
}

// Atajo: Para crear un StatelessWidget, solo teclear stl y seleccionar el tipo
// de widget a crear (Stateless o Stateful)
class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // Iniciar los controladores de texto para el email y la contraseña
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    // SIEMPRE: Eliminar los controladores al finalizar la pantalla
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold() agrega todos los componentes del widget.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Ingrese su email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Ingrese su contraseña',
            ),
          ),
          TextButton(
            onPressed: () async {
              await Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              );

              // Aqui vamos a crear el usuario en firebase.
              final email = _email.text;
              final password = _password.text;

              final userCredentials = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email, password: password);
            },
            child: const Text('Registrarse'),
          ),
        ],
      ),
    );
  }
}
