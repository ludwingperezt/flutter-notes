import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

/// Servicio de autenticación que hace uso de un AuthProvider.

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  @override
  Future<void> cerrarSesion() => provider.cerrarSesion();

  @override
  Future<AuthUser> crearUsuario(
          {required String email, required String password}) =>
      provider.crearUsuario(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> enviarEmailVerificacion() => provider.enviarEmailVerificacion();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);
}
