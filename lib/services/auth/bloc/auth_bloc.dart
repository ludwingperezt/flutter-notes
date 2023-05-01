import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Todo bloc class debe tener un estado inicial
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    // evento de incialización
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        // al inicio, cuando la aplicación carga, el usuario no está por defecto
        // y tampoco se está cargando nada y no hay excepciones.
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // Evento de login
    on<AuthEventLogIn>((event, emit) async {
      //
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          // Si el usuario no tiene verificado su email, mantener al usuario
          // NO loggeado y enviar el evento para verificar email.
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification());
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        // En este bloque es necesario colocar on Exception catch (e) porque
        // en dart cualquier objeto puede ser lanzado como una excepción, pero
        // el estado AuthStateLoginFailure solo acepta objetos que sean derivados
        // de Exception.
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    // Evento logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.cerrarSesion();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    // Manejo del evento cuando se envía el email de verificación.
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.enviarEmailVerificacion();
      // Cuando se envía el email de verificación no hay cambio de estado.
      emit(state);
    });

    // Manejo del evento de registro de nuevo usuario.
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          // Registrar al usuario y luego inmediatamente después, enviar el email
          // de verificación.
          await provider.crearUsuario(email: email, password: password);
          await provider.enviarEmailVerificacion();

          emit(const AuthStateNeedsVerification());
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );
  }
}
