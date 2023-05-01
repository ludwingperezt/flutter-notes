import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/inicio_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notas/crear_editar_nota_view.dart';
import 'package:mynotes/views/notas_view.dart';
import 'package:mynotes/views/registro_view.dart';
import 'package:mynotes/views/verificar_email_view.dart';

/// La función main() NO ES INVOCADA durante los hot reloads.
void main() async {
  // Cargar el archivo de variables de entorno.
  await dotenv.load(fileName: ".env");

  // Se habilita Wigdet Binding antes de iniciar Firebase
  // https://docs.flutter.dev/resources/architectural-overview#architectural-layers
  WidgetsFlutterBinding.ensureInitialized();

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
      home: BlocProvider<AuthBloc>(
        // Aqui se usa BlocProvider para inicializar el bloc AuthBloc.
        // En este caso al context que se está pasando a la inline function
        // se le está inyectando el AuthBloc para que esté disponible para toda
        // la app.
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const InicioView(),
      ),
      // Creación de las rutas de la app:
      routes: {
        loginRoute: (context) => const LoginView(),
        registroRoute: (context) => const RegistroView(),
        notasRoute: (context) => const NotasView(),
        verificarEmailRoute: (context) => const VerificarEmailView(),
        nuevaEditarNotaRoute: (context) => const CrearEditarNotaView(),
      },
    ),
  );
}
