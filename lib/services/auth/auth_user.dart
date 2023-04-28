import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// Este es una clase que se usa para abstraer el usuario de Firebase a la UI
@immutable
class AuthUser {
  final bool isEmailVerified;

  final String email;

  final String id;

  // Al colocar {required this.isEmailVerified} como parámetro del constructor
  // se habilita que un objeto de tipo AuthUser pueda ser creado nombrando el
  // nombre del parámetro, por ejemplo:
  // const user = AuthUser(isEmailVerified: true);
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  // Aplicación del patrón factory.
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
