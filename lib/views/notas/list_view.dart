import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/delete_dialog.dart';
import 'package:mynotes/services/crud/notas_service.dart';

typedef EliminarNotaCallback = void Function(DatabaseNota nota);

class NotasListView extends StatelessWidget {
  final List<DatabaseNota> notas;

  final EliminarNotaCallback onEliminarNota;

  const NotasListView({
    super.key,
    required this.notas,
    required this.onEliminarNota,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notas.length,
      itemBuilder: (context, index) {
        // obtener cada nota en la lista según su índice
        final nota = notas[index];

        // ListTile representa a cada uno de los elementos
        // de la lista. Cada uno de estos elementos mostrará
        // una parte del texto (si es muy largo) y será
        // recortado a una línea con puntos suspensivos
        // al final de la línea.
        return ListTile(
          title: Text(
            nota.texto,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              // Mostrar el dialogo para confirmar que se elimina la nota.
              final confirmarEliminar = await showEliminarDialog(context);

              if (confirmarEliminar) {
                onEliminarNota(nota);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
