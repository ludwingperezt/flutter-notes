import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

/// Esta es una extensión para BuildContext que se usará en los archivos de views
/// para tener acceso fácil a la clase que provee los textos traducidos.
/// De esta manera, al definir el texto de un widget, en lugar de hacer esto:
///
///     Text(AppLocalizations.of(this)!.my_text)
///
/// Se haría esto:
///
///     import 'package:mynotes/extensions/buildcontext/loc.dart';
///     ...
///     Text(context.loc.my_text)
extension Localization on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
