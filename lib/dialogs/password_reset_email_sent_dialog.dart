import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';

// Este es un dialog para indicar al ususario que ya se ha enviado el email
// para recuperar contraseña.
Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    contexto: context,
    titulo: 'Recuperar contraseña',
    contenido:
        'Hemos enviado un link para que recuperes tu contraseña. Revisa su email',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
