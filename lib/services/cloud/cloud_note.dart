import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

/// Esta clase representa una nota en Firestore
@immutable
class CloudNota {
  final String documentId;
  final String ownerUserId;
  final String texto;

  const CloudNota({
    required this.documentId,
    required this.ownerUserId,
    required this.texto,
  });

  // Constructor que genera una instancia de CloudNota a partir de un snapshot
  // (que es la representación de datos que se obtienen de firebase).
  CloudNota.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        texto = snapshot.data()[textoFieldName] as String;
}
