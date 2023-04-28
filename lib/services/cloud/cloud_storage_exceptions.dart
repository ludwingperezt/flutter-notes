/// Excepciones especiales de firestore.
///

/// Clase base para todas las expeciones lanzadas por Firestore
class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNotaException extends CloudStorageException {}

class CouldNotUpdateNotaException extends CloudStorageException {}

class CouldNotGetAllNotasException extends CloudStorageException {}

class CouldNotDeleteNotaException extends CloudStorageException {}
