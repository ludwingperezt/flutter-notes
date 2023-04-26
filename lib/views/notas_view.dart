import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/dialogs/show_confirmar_logout_dialog.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/services/auth/auth_service.dart';

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
                    await AuthService.firebase().cerrarSesion();

                    // context.mounted resuelve esta advertencia:
                    // Don't use 'BuildContext's across async gaps. Try rewriting the code to not reference the 'BuildContext'
                    // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
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
