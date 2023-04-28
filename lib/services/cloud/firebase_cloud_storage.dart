import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // En esta línea se hace la comunicación con Firebase.  Esta línea lo que devuelve
  // es una especie de Stream pero de lectura/escritura sobre el cual se hacen
  // las operaciones de lectura escritura.
  final notas = FirebaseFirestore.instance.collection(collectionName);

  // implementar Singleton para esta clase
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance(); // Este es un constructor privado.
  // Este es un factory constructor, que es el constructor por defecto de la clase,
  // el cual retorna siempre la instancia _shared la cual es un objeto estático
  // y final que a su vez llama al constructor privado de la clase.
  factory FirebaseCloudStorage() => _shared;

  void crearNuevaNota({required String ownerUserId}) async {
    // Al crear una nota, ésta se crea vacía.
    await notas.add({
      ownerUserIdFieldName: ownerUserId,
      textoFieldName: '',
    });
  }

  Future<Iterable<CloudNota>> obtenerNotas(
      {required String ownerUserId}) async {
    try {
      // Filtrar las notas que pertenecen al usuario cuyo ID se ha recibido en
      // los parámetros de la función.
      return await notas
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (document) {
                // Aquí se mapea de los datos del snapshot de firebase a objetos
                // de tipo CloudNota
                return CloudNota(
                  documentId: document.id,
                  ownerUserId: document.data()[ownerUserIdFieldName] as String,
                  texto: document.data()[textoFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotasException();
    }
  }

  // Retornar un stream al cual se pueda suscribir la UI para mostrar la lista
  // de notas existentes pero filtrando solo aquellas que pertenecen al usuario.
  Stream<Iterable<CloudNota>> todasNotas({required String ownerUserId}) =>
      notas.snapshots().map((event) => event.docs
          .map((document) => CloudNota.fromSnapshot(document))
          .where((nota) => nota.ownerUserId == ownerUserId));

  Future<void> actualizarNota({
    required String documentId,
    required String texto,
  }) async {
    try {
      notas.doc(documentId).update({textoFieldName: texto});
    } catch (e) {
      throw CouldNotUpdateNotaException();
    }
  }

  Future<void> eliminarNota({required String documentId}) async {
    try {
      await notas.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNotaException();
    }
  }
}
