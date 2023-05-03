import 'package:flutter/material.dart';
import 'package:mynotes/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:share_plus/share_plus.dart';

class CrearEditarNotaView extends StatefulWidget {
  const CrearEditarNotaView({super.key});

  @override
  State<CrearEditarNotaView> createState() => _CrearEditarNotaViewState();
}

/// El flujo de uso para la creación de una nota es que cuando el usuario
/// entra a la vista de creación de nota, se crea una nota en la base de datos.
/// Mientras va escribiendo, se va actualizando la nota en la base de datos.
/// Al salir de la vista (haciendo clic en el botón atrás), si el texto está
/// vacío, la nueva nota se elimina, de lo contrario se actualiza una vez más.
class _CrearEditarNotaViewState extends State<CrearEditarNotaView> {
  CloudNota? _nota;

  late final FirebaseCloudStorage _notasService;

  // Una buena práctica para el uso de un TextEditingController es SIEMPRE
  // hacer un dispose de este elemento cuando se hace el dispose de la view.
  late final TextEditingController _textController;

  Future<CloudNota> crearObtenerNota(BuildContext contexto) async {
    // Aquí se hace uso del extension ObtenerArgument agregado a la clase
    // BuildContext para obtener el parámetro que pudo ser enviado o no desde
    // el punto donde se hizo el llamado a esta vista.
    final widgetNota = context.obtenerArgument<CloudNota>();

    if (widgetNota != null) {
      _nota = widgetNota;
      _textController.text = widgetNota.texto;
      return widgetNota;
    }

    final existeNota = _nota;
    if (existeNota != null) {
      return existeNota;
    }

    final usuarioActual = AuthService.firebase().currentUser;
    final userId = usuarioActual!.id;
    final nuevaNota = await _notasService.crearNota(ownerUserId: userId);
    _nota = nuevaNota;
    return nuevaNota;
  }

  void _eliminarNotaSiEsVacia() {
    // Si la nota está vacía, eliminarla
    final nota = _nota;

    if (_textController.text.isEmpty && nota != null) {
      _notasService.eliminarNota(documentId: nota.documentId);
    }
  }

  void _guardarNotaSiTextoNoEsVacio() async {
    // Si el texto de la nota no es vacío, actualizar la nota.
    final nota = _nota;
    final texto = _textController.text;

    if (nota != null && texto.isNotEmpty) {
      await _notasService.actualizarNota(
          documentId: nota.documentId, texto: texto);
    }
  }

  void _textControllerListener() async {
    final nota = _nota;

    if (nota == null) {
      return;
    }

    final texto = _textController.text;
    await _notasService.actualizarNota(
      documentId: nota.documentId,
      texto: texto,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notasService = FirebaseCloudStorage();
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
  Widget build(BuildContext contexto) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.new_note,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_nota == null || text.isEmpty) {
                await showCannotShareEmptyNotaDialog(context);
              } else {
                // Aqui es donde se comparte el texto de la nota.
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: FutureBuilder(
        // En esta parte se usa un futureBuilder porque al abrir la view
        // lo que se hace es insertar una nueva nota en la db si no se recibió
        // una nota como parámetro, de lo contrario se manda a traer a la db
        // la nota que ya existe.
        future: crearObtenerNota(contexto),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines:
                    null, // esto es para que el campo se expanda a medida que se agrega texto.
                decoration: InputDecoration(
                  hintText: context.loc.write_your_note,
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
