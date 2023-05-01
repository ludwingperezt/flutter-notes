import 'package:flutter/material.dart';

// Aquí se define el tipo CloseDialog como una función que no retorna nada.
typedef CloseDialog = void Function();

CloseDialog mostrarCargandoDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(text),
      ],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible:
        false, // este parametro indica si al hacer clic fuera del dialogo, éste se cierra.
    builder: (context) => dialog, // solamente retornar el diálogo.
  );

  // Se retorna una función para cerrar el diálogo.
  return () => Navigator.of(context).pop();
}
