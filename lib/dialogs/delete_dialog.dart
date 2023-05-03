import 'package:flutter/widgets.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';

Future<bool> showEliminarDialog(BuildContext contexto) {
  return showGenericDialog<bool>(
    contexto: contexto,
    titulo: contexto.loc.delete,
    contenido: contexto.loc.confirm_delete,
    optionsBuilder: () => {
      contexto.loc.cancel: false,
      contexto.loc.delete: true,
    },
  ).then((value) => value ?? false);

  // el .then() se coloca para que el dialog siempre retorne un valor. Si por
  // alguna razón el valor que resulta de mostrar el dialogo es null entonces
  // se retorna false
}
