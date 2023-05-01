import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Todo bloc class debe tener un estado inicial
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // evento de incialización
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // Evento de login
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        // En este bloque es necesario colocar on Exception catch (e) porque
        // en dart cualquier objeto puede ser lanzado como una excepción, pero
        // el estado AuthStateLoginFailure solo acepta objetos que sean derivados
        // de Exception.
        emit(AuthStateLoggedOut(e));
      }
    });

    // Evento logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.cerrarSesion();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
