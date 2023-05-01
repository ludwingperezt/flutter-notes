import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

// Evento para inicializar firebase
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

/// Evento para disparar el envío del email de verificación.
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

/// Evento para registrar un nuevo usuario
class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister(this.email, this.password);
}

// Inicio para desencadenar el registro de un usuario nuevo.
class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}
