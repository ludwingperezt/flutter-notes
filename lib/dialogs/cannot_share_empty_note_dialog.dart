import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNotaDialog(BuildContext context) {
  return showGenericDialog(
    contexto: context,
    titulo: 'Compartir',
    contenido: 'No puedes compartir una nota vacía',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
