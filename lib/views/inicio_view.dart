import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notas_view.dart';
import 'package:mynotes/views/verificar_email_view.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      // FutureBuilder se usa para inicializar un widget HASTA que una promesa se haya completado, en este caso hasta que la app Firebase se haya iniciado.
      builder: (context, snapshot) {
        // La función builder SIEMPRE debe retornar un widget.

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
            final user = AuthService.firebase().currentUser;
            final emailVerified = user?.isEmailVerified ?? false;

            if (user == null) {
              return const LoginView();
            }

            if (emailVerified) {
              return const NotasView();
            } else {
              return const VerificarEmailView();
            }

          // if (emailVerified) {
          //   print('Loggeado!');
          // } else {
          //   print('No loggeado');

          //   // Lo que se hace aqui es que dentro de la misma pantalla se está
          //   // colocando un Widget, en este caso es el widget de verificación
          //   // de correo.
          //   return const VerificarEmailView();
          // }

          // return const Text('Hecho!');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
