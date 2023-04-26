import 'package:flutter/foundation.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

// Estas constantes son los nombres de los campos en la base de datos.
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textoColumn = 'texto';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const dbName = 'notas.db';
const notasTable = 'nota';
const userTable = 'user';
const crearUserTableSql = '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';
const crearNotaTableSql = '''CREATE TABLE IF NOT EXISTS "nota" (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "texto" TEXT,
        "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';

// Esta clase es la que crea y mantiene la conexión con la db.
class NotasService {
  Database? _db;

  Future<DatabaseNota> actualizarNota({
    required DatabaseNota nota,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();

    await obtenerNota(id: nota.id);

    final countUpdates = await db.update(notasTable, {
      textoColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (countUpdates == 0) {
      throw ImposibleActualizarNotaExcepcion();
    } else {
      return await obtenerNota(id: nota.id);
    }
  }

  Future<Iterable<DatabaseNota>> listarNotas() async {
    final db = _getDatabaseOrThrow();

    final notas = await db.query(notasTable);

    return notas.map((notaFila) => DatabaseNota.fromRow(notaFila));
  }

  Future<DatabaseNota> obtenerNota({required int id}) async {
    final db = _getDatabaseOrThrow();

    final notas = await db.query(
      notasTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notas.isEmpty) {
      throw NotaNoEncontradaException();
    } else {
      return DatabaseNota.fromRow(notas.first);
    }
  }

  Future<int> eliminarTodasNotas() async {
    final db = _getDatabaseOrThrow();

    return await db.delete(notasTable);
  }

  Future<void> eliminarNota({required int id}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      notasTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw ImposibleEliminarNotaException();
    }
  }

  Future<DatabaseNota> crearNota({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // con esto se asegura que el usuario existe en la base de datos con el ID
    // correcto.
    final dbUser = await obtenerUser(email: owner.email);
    if (dbUser != owner) {
      throw UsuarioNoEncontradoException();
    }

    const texto = '';

    final notaId = await db.insert(notasTable, {
      userIdColumn: owner.id,
      textoColumn: texto,
      isSyncedWithCloudColumn: 1
    });

    final nota = DatabaseNota(
      id: notaId,
      userId: owner.id,
      texto: texto,
      isSyncedWithCloud: true,
    );

    return nota;
  }

  Future<DatabaseUser> obtenerUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw UsuarioNoEncontradoException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> crearUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UsuarioExisteException();
    }

    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});

    return DatabaseUser(id: userId, email: email);
  }

  Future<void> eliminarUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) {
      throw ImposibleEliminarUsuarioException();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;

    if (db == null) {
      throw DatabaseNoAbiertaException();
    } else {
      return db;
    }
  }

  Future<void> cerrarDB() async {
    final db = _db;

    if (db == null) {
      throw DatabaseNoAbiertaException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> abrirDb() async {
    if (_db != null) {
      // Esta condición evita que se abran múltiples conexiones a la db cuando
      // ésta ya está abierta.
      throw DatabaseAbiertaException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();

      final dbPath = join(docsPath.path, dbName);

      final db = await openDatabase(dbPath);

      _db = db;

      // Crear la tabla de usuarios
      await db.execute(crearUserTableSql);
      // Crear la tabla de notas.
      await db.execute(crearNotaTableSql);
    } on MissingPlatformDirectoryException {
      throw ImposibleObtenerDirectorioDocumentosException();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  // fromRow() es una función que mapea el resultado de una consulta a la base
  // de datos y a partir de ello crea un objeto de la clase. Esta función crea
  // un objeto por cada fila obtenida.
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Persona, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNota {
  final int id;
  final int userId;
  final String texto;
  final bool isSyncedWithCloud;

  DatabaseNota(
      {required this.id,
      required this.userId,
      required this.texto,
      required this.isSyncedWithCloud});

  DatabaseNota.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        texto = map[textoColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() => 'Nota, ID=$id, userId=$userId synced=$isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNota other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
