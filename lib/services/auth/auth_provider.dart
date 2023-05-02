// Un provider es una abstracción de cualquier proveedor de autenticación que
// se pueda implementar en el futuro.
// Cada proveedor debe cumplir con un contrato para que la interfaz de interacción
// se mantenga estándar.
import 'package:mynotes/services/auth/auth_user.dart';

// Esta es una interfaz que TODOS los proveedores de autenticación deben cumplir.
abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> crearUsuario({
    required String email,
    required String password,
  });

  Future<void> cerrarSesion();

  Future<void> enviarEmailVerificacion();

  Future<void> enviarPasswordReset({required String toEmail});
}
