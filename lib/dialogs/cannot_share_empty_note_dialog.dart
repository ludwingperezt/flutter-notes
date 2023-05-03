import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/generic_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';

Future<void> showCannotShareEmptyNotaDialog(BuildContext context) {
  return showGenericDialog(
    contexto: context,
    titulo: context.loc.share,
    contenido: context.loc.share_empty_note_not_allowed,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
