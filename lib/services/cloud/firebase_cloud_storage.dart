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

  Future<CloudNota> crearNota({required String ownerUserId}) async {
    // Al crear una nota, ésta se crea vacía.
    final document = await notas.add({
      ownerUserIdFieldName: ownerUserId,
      textoFieldName: '',
    });

    // Al guardar una nota con .add no se retorna el snapshot con los datos creados
    // sino que para obtenerlo hay que llamarlo con .get()
    final fetchedNota = await document.get();
    return CloudNota(
        documentId: fetchedNota.id, ownerUserId: ownerUserId, texto: '');
  }

  // Retornar un stream al cual se pueda suscribir la UI para mostrar la lista
  // de notas existentes pero filtrando solo aquellas que pertenecen al usuario.
  Stream<Iterable<CloudNota>> todasNotas({required String ownerUserId}) {
    // Al poner el where() antes de snapshots() nos aseguramos de hacer el
    // filtrado antes de obtener los datos.
    final listaNotas = notas
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) =>
            event.docs.map((document) => CloudNota.fromSnapshot(document)));
    return listaNotas;
  }

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
