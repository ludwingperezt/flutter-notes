import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// Este es una clase que se usa para abstraer el usuario de Firebase a la UI
@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  // Aplicación del patrón factory.
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
