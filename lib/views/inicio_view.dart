/// Esta view es la view principal de la aplicación desde la cual se dirigirá
/// al usuario a la pantalla de login si no está registrado.
/// Esta vista es la que inicia la aplicación.  Es la vista raíz.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        // FutureBuilder se usa para inicializar un widget HASTA que una promesa se haya completado, en este caso hasta que la app Firebase se haya iniciado.
        builder: (context, snapshot) {
          // a través de snapshot se puede obtener el estado de la promesa (Future)
          // y realizar alguna acción mientras se espera que se resuelva y cuando
          // se reciba una respuesta, ya sea exitosa o sea un error.

          switch (snapshot.connectionState) {
            // TODO: Pendiente de implementar los otros casos de estado del Future
            // case ConnectionState.none:
            //   // TODO: Handle this case.
            //   break;
            // case ConnectionState.waiting:
            //   // TODO: Handle this case.
            //   break;
            // case ConnectionState.active:
            //   // TODO: Handle this case.
            //   break;

            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;

              if (emailVerified) {
                print('Loggeado!');
              } else {
                print('No loggeado');
              }

              return const Text('Hecho!');
            default:
              return const Text('Cargando...');
          }
        },
      ),
    );
  }
}
