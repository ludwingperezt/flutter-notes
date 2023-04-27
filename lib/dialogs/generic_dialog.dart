import 'package:flutter/material.dart';

// La siguiente pieza de código define un tipo para los botones del dialogo,
// ya que cada botón debe tener un texto y un valor que se retorna cuando el
// usuario hace clic sobre el botón.  Todos los botones deben tener el mismo
// tipo de dato para el valor que retornan (por eso el value del map es T?).
// Cada botón es representado por un Map donde el texto a mostrar es un string
// y el valor es un generic T?
// Cada key dentro del map de opciones es el texto o título de cada botón.
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext contexto,
  required String titulo,
  required String contenido,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();

  return showDialog<T>(
    context: contexto,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: options.keys.map((opcionTitulo) {
          final value = options[opcionTitulo];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(opcionTitulo),
          );
        }).toList(),
      );
    },
  );
}
