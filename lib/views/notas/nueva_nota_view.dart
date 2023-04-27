import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notas_service.dart';

class NuevaNotaView extends StatefulWidget {
  const NuevaNotaView({super.key});

  @override
  State<NuevaNotaView> createState() => _NuevaNotaViewState();
}

/// El flujo de uso para la creación de una nota es que cuando el usuario
/// entra a la vista de creación de nota, se crea una nota en la base de datos.
/// Mientras va escribiendo, se va actualizando la nota en la base de datos.
/// Al salir de la vista (haciendo clic en el botón atrás), si el texto está
/// vacío, la nueva nota se elimina, de lo contrario se actualiza una vez más.
class _NuevaNotaViewState extends State<NuevaNotaView> {
  DatabaseNota? _nota;

  late final NotasService _notasService;

  // Una buena práctica para el uso de un TextEditingController es SIEMPRE
  // hacer un dispose de este elemento cuando se hace el dispose de la view.
  late final TextEditingController _textController;

  Future<DatabaseNota> crearNota() async {
    final existeNota = _nota;
    if (existeNota != null) {
      return existeNota;
    }

    final usuarioActual = AuthService.firebase().currentUser;
    final email = usuarioActual!.email ?? '';
    final owner = await _notasService.obtenerUser(email: email);
    return await _notasService.crearNota(owner: owner);
  }

  void _eliminarNotaSiEsVacia() {
    // Si la nota está vacía, eliminarla
    final nota = _nota;

    if (_textController.text.isEmpty && nota != null) {
      _notasService.eliminarNota(id: nota.id);
    }
  }

  void _guardarNotaSiTextoNoEsVacio() async {
    // Si el texto de la nota no es vacío, actualizar la nota.
    final nota = _nota;
    final texto = _textController.text;

    if (nota != null && texto.isNotEmpty) {
      await _notasService.actualizarNota(
        nota: nota,
        text: texto,
      );
    }
  }

  void _textControllerListener() async {
    final nota = _nota;

    if (nota == null) {
      return;
    }

    final texto = _textController.text;
    await _notasService.actualizarNota(
      nota: nota,
      text: texto,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notasService = NotasService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _eliminarNotaSiEsVacia();
    _guardarNotaSiTextoNoEsVacio();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva nota'),
      ),
      body: FutureBuilder(
        future: crearNota(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _nota = snapshot.data as DatabaseNota;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines:
                    null, // esto es para que el campo se expanda a medida que se agrega texto.
                decoration:
                    const InputDecoration(hintText: 'Escribe tu texto aqui'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
