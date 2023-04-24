import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

class NotasView extends StatefulWidget {
  const NotasView({super.key});

  @override
  State<NotasView> createState() => _NotasViewState();
}

class _NotasViewState extends State<NotasView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final debeCerrarSesion = await mostrarLogOutDialog(context);
                  devtools.log(debeCerrarSesion.toString());

                  if (debeCerrarSesion) {
                    // Hacer logout de Firebase.
                    await FirebaseAuth.instance.signOut();

                    // context.mounted resuelve esta advertencia:
                    // Don't use 'BuildContext's across async gaps. Try rewriting the code to not reference the 'BuildContext'
                    // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login/', (_) => false);
                    }
                  }
                  break;
              }

              // A menera de ejemplo se muestra el código que envía a log
              // la opción seleccionada del menú ubicado en el appbar.
              // Usar log es mejor que usar print()
              devtools.log(value.toString());
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Cerrar sesión'),
                )
              ];
            },
          )
        ],
      ),
      body: const Text('Bienvenido!'),
    );
  }
}

Future<bool> mostrarLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Salir'),
        content: const Text('Está seguro de cerrar sesión?'),
        actions: [
          TextButton(
              onPressed: () {
                // Indicar que el usuario canceló el modal
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                // Indicar que el usuario confirmó el cierre de la sesión
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out')),
        ],
      );
    },
  ).then((value) =>
      value ??
      false); // esta línea es para especificar un valor de retorno cuando el usuario descarta el popup con el botón "Atras" o cuando hace clic en la pantalla para cerrar el diálogo.
}
