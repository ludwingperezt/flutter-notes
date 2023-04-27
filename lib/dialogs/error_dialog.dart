import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';

// Este dialogo para mostrar errores hace uso del diálogo genérico.
Future<void> mostrarErrorDialog(
  BuildContext contexto,
  String texto,
) {
  return showGenericDialog(
    contexto: contexto,
    titulo: 'Error',
    contenido: texto,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
