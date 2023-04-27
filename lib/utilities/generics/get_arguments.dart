import 'package:flutter/material.dart' show BuildContext, ModalRoute;

/// Esta es una extensión para obtener los parámetros enviados a una view
/// sin importar su tipo.
extension ObtenerArgument on BuildContext {
  T? obtenerArgument<T>() {
    final modalRoute = ModalRoute.of(this);

    if (modalRoute != null) {
      // Aquí se obtienen los parámetros tal y como fueron enviados desde el
      // punto en que se invocó a la función.
      final args = modalRoute.settings.arguments;

      // Si los argumentos recibidos no son null Y el tipo de dato del
      // argumento es el mismo que el del tipo de dato que se está pidiendo
      // en la declaración del extension, entonces extraer el dato y retornarlo,
      // de lo contrario retornar null.
      if (args != null && args is T) {
        return args as T;
      }

      return null;
    }
  }
}
