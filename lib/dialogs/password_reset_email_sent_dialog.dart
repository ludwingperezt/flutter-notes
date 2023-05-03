import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';

// Este es un dialog para indicar al ususario que ya se ha enviado el email
// para recuperar contraseña.
Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    contexto: context,
    titulo: context.loc.reset_password,
    contenido: context.loc.reset_password_email_sent,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
