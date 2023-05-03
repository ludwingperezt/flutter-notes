import 'package:flutter/widgets.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';

Future<bool> mostrarLogOutDialog(BuildContext contexto) {
  return showGenericDialog<bool>(
    contexto: contexto,
    titulo: contexto.loc.go_out,
    contenido: contexto.loc.go_out_confirm,
    optionsBuilder: () => {
      contexto.loc.cancel: false,
      contexto.loc.go_out: true,
    },
  ).then((value) => value ?? false);

  // el .then() se coloca para que el dialog siempre retorne un valor. Si por
  // alguna razón el valor que resulta de mostrar el dialogo es null entonces
  // se retorna false
}
