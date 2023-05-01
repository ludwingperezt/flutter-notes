import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  // IMplementar un patrón singleton para esta clase
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  // El LoadingScreenController sirve para realizar acciones en la pantalla
  // overlay, tal como actualizarla o cerrarla.
  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    // Si el contenido del controller se puede actualizar, entonces actualizarlo
    // y nada más. De lo contrario crear un nuevo overlay.
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(context: context, text: text);
    }
  }

  // Función para cerrar el diálogo overlay
  void hide() {
    controller?.close();
    controller = null;
  }

  // Función para mostrar el dialog overlay
  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    // Crear un StreamController y a ese stream agregarle el texto recibido.
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);

    // A través del renderBox se podrá obtener el tamaño que tendrá el overlay
    // en la pantalla.
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        // Overlays no tienen un padre como scaffold, así que los componentes o
        // widgets que retornen del builder deben estar envueltos en un Scaffold
        // o material para que puedan tener un estilo.
        // Material Crea un Stateful widget con un estilo predeterminado, para que
        // los componentes a mostrar puedan mostrarse con un estilo acorde
        // al estilo del sistema.
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width *
                    0.8, // El ancho del dialog será de un máximo de 80% de la pantalla.
                maxHeight: size.width * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                // Aplicar un borde a la pantalla
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Si no se usa SingleChildScrollView y el contenido es muy largo
                // al mostrarse en una pantalla pequeña, simplemente se va a cortar
                // ya que se ha declarado un alto máximo de 80% de la pantalla.
                // Este componente permite hacer scroll del contenido que es muy
                // grande.
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // En este punto se muestra el overlay en la pantalla.
    state.insert(overlay);

    // retornar el Controller de la pantalla overlay para que pueda cerrarse
    // o actualizarse.
    return LoadingScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
