import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/dialogs/logout_dialog.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/views/notas/list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

class NotasView extends StatefulWidget {
  const NotasView({super.key});

  @override
  State<NotasView> createState() => _NotasViewState();
}

class _NotasViewState extends State<NotasView> {
  // Exponer el email del usuario loggeado
  String get userId => AuthService.firebase().currentUser!.id;

  late final FirebaseCloudStorage _notasService;

  @override
  void initState() {
    _notasService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(nuevaEditarNotaRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final debeCerrarSesion = await mostrarLogOutDialog(context);
                  devtools.log(debeCerrarSesion.toString());

                  if (debeCerrarSesion && context.mounted) {
                    // Hacer el cierre de sesión con AuthBloc
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
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
      body: StreamBuilder(
        stream: _notasService.todasNotas(ownerUserId: userId),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            // case ConnectionState.none:
            //   break;
            // Cuando dos condiciones case están juntas significa que
            // la acción que realizan es la misma:
            case ConnectionState.active:
            case ConnectionState.waiting:
              if (snapshot.hasData) {
                final todasNotas = snapshot.data as Iterable<CloudNota>;

                // En este punto el listview de las notas se envió a un
                // archivo aparte el cual define un callback para cuando
                // se quiera eliminar una nota haciendo clic en el botón
                // del ícono de basura al lado derecho de la nota.
                return NotasListView(
                  notas: todasNotas,
                  onEliminarNota: (nota) async {
                    await _notasService.eliminarNota(
                        documentId: nota.documentId);
                  },
                  onTap: (nota) {
                    Navigator.of(context).pushNamed(
                      nuevaEditarNotaRoute,
                      arguments: nota,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
