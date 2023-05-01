/// Cuando se trabaja con bloc, es necesario definir estados que son resultado
/// de los eventos que se pueden producir y que ingresan al bloc class.
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

/// Todos los estados derivarán de esta super clase.
@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateLogoutFailure extends AuthState {
  final Exception exception;

  const AuthStateLogoutFailure(this.exception);
}
