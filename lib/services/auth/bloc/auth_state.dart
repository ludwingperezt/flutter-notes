/// Cuando se trabaja con bloc, es necesario definir estados que son resultado
/// de los eventos que se pueden producir y que ingresan al bloc class.
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

/// Todos los estados derivarán de esta super clase.
@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Por favor, espera un momento',
  });
}

// Inidica que la aplicación no ha inicializado.
class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

/// Estado para indicar que se está haciendo un evento de registro.
class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

/// Cuando se abre la aplicación, el estado es loggedOut sin ninguna excepción
/// (no ha sucedido ningún error) y isLoading es false porque no se está cargando
/// nada.  Cuando se ingresan las credenciales para hacer login, el estado sigue
/// siendo LoggedOut, no hay ninguna excepción, pero isLoading es true porque
/// ahora sí se está haciendo la carga de datos del usuario.
/// Si por ejemplo las credenciales no son válidas, el estado sigue siendo
/// LoggedOut pero ahora sí hay una excepción y isLoading es false.
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading, loadingText: loadingText);

  /// el getter props que se está sobrescribiendo define qué campos del objeto
  /// deben tomarse en cuenta al momento de diferenciar la igualdad de dos objetos
  /// de la misma clase, pero en base a los valores de las variables de instancia.
  @override
  List<Object?> get props => [exception, isLoading];
}
