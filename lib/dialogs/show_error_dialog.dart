/// Dialog usado para mostrar errores al usuario.

import 'package:flutter/material.dart';

Future<void> mostrarErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              // Al hacer clic en el botón OK, se descarta el dialog actual.
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
