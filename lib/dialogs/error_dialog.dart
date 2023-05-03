import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';

// Este dialogo para mostrar errores hace uso del diálogo genérico.
Future<void> mostrarErrorDialog(
  BuildContext contexto,
  String texto,
) {
  return showGenericDialog(
    contexto: contexto,
    titulo: contexto.loc.error,
    contenido: texto,
    optionsBuilder: () => {
      contexto.loc.ok: null,
    },
  );
}
