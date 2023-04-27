import 'package:flutter/widgets.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';

Future<bool> mostrarLogOutDialog(BuildContext contexto) {
  return showGenericDialog<bool>(
    contexto: contexto,
    titulo: 'Salir',
    contenido: 'Está seguro de cerrar sesión?',
    optionsBuilder: () => {
      'Cancelar': false,
      'Salir': true,
    },
  ).then((value) => value ?? false);

  // el .then() se coloca para que el dialog siempre retorne un valor. Si por
  // alguna razón el valor que resulta de mostrar el dialogo es null entonces
  // se retorna false
}
