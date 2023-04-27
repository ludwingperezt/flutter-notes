import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/dialogs/show_confirmar_logout_dialog.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notas_service.dart';

class NotasView extends StatefulWidget {
  const NotasView({super.key});

  @override
  State<NotasView> createState() => _NotasViewState();
}

class _NotasViewState extends State<NotasView> {
  // Exponer el email del usuario loggeado
  String get userEmail => AuthService.firebase().currentUser!.email!;

  late final NotasService _notasService;

  @override
  void initState() {
    _notasService = NotasService();
    super.initState();
  }

  @override
  void dispose() {
    _notasService.cerrarDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(nuevaNotaRoute);
            },
            icon: const Icon(Icons.add),
          ),
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
      body: FutureBuilder(
        // Con el FutureBuilder se hace una suscripción al Future para insertar
        // o crear el registro del email del usuario en la base de datos local.
        // Dependendo del estado del Future se renderizará la lista de notas
        // a través de un StreamBuilder o un Progress Indicator mientras se
        // espera una respuesta.
        future: _notasService.obtenerCrearUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
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
              // Para mostrar todas las notas se usa un StreamBuilder que se
              // suscribe al stream para obtener todas las notas.
              return StreamBuilder(
                stream: _notasService.todasNotas,
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    // case ConnectionState.none:
                    //   // TODO: Handle this case.
                    //   break;
                    case ConnectionState.waiting:
                      return const Text('Esperando cargar todas las notas...');
                      // case ConnectionState.active:
                      //   // TODO: Handle this case.
                      //   break;
                      // case ConnectionState.done:
                      //   // TODO: Handle this case.
                      break;
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
