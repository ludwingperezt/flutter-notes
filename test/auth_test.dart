import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  // Un group sirve para agrupar tests relacionados.
  group('Mock autenticacion', () {
    final provider = MockAuthProvider();

    test('Para empezar el provider no debe estar inicializado', () {
      expect(provider.haIniciado, false);
    });

    test('No hacer logout si no se ha iniciado', () {
      expect(
        provider.cerrarSesion(),
        throwsA(const TypeMatcher<NoIniciadaException>()),
      );
    });

    test('Debería iniciarlizarse', () async {
      await provider.initialize();
      expect(provider.haIniciado, true);
    });

    test('Usuario deberia ser null despues de inicializar', () {
      expect(provider.currentUser, null);
    });

    test('Debería fallar inicilización en menos de 2 segundos', () async {
      await provider.initialize();
      expect(provider.haIniciado, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Crear un usuario debe delegar a la funcion logIn', () async {
      final badEmailUser = provider.crearUsuario(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      /////////////////////////
      final badPasswordUser = provider.crearUsuario(
        email: 'x@bar.com',
        password: 'foobar',
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      //////////////////////////////////////////////////////////////////////////

      final user = await provider.crearUsuario(
        email: 'x@bar.com',
        password: 'xyz',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Usuario loggeado deberia poder ser verificado', () async {
      provider.enviarEmailVerificacion();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });

    test('Debería poder cerrar sesion y entrar de nuevo', () async {
      await provider.cerrarSesion();
      await provider.logIn(email: 'x@t.com', password: 'xyz');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NoIniciadaException implements Exception {}

class MockAuthProvider implements AuthProvider {
  // La variable _haIniciado controla si el provider ya ha iniciado (a través)
  // del método initialize()
  var _haIniciado = false;

  bool get haIniciado => _haIniciado;

  AuthUser? _user;

  @override
  Future<void> cerrarSesion() async {
    if (!haIniciado) throw NoIniciadaException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> crearUsuario({
    required String email,
    required String password,
  }) async {
    // Esta función imita el funcionamiento de crearUsuario().
    // En primer lugar se lanza una excepción cuando se llama al método pero si no
    // ha inicializado la conexión con el backend.
    if (!haIniciado) throw NoIniciadaException();

    // Aqui se simula el tiempo de espera con la conexión del backend.
    await Future.delayed(const Duration(seconds: 1));

    // Al usuario creado se le hace login
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> enviarEmailVerificacion() async {
    if (!haIniciado) throw NoIniciadaException();

    final user = _user;

    if (user == null) throw UserNotFoundAuthException();

    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<void> initialize() async {
    // Se finge una espera para iniciar la clase
    await Future.delayed(const Duration(seconds: 1));
    _haIniciado = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!haIniciado) throw NoIniciadaException();

    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();

    const user = AuthUser(isEmailVerified: false);
    _user = user;

    return Future.value(user);
  }
}
