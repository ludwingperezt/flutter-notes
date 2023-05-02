import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Todo bloc class debe tener un estado inicial
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // evento de incialización
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        // al inicio, cuando la aplicación carga, el usuario no está por defecto
        // y tampoco se está cargando nada y no hay excepciones.
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // Evento de login
    on<AuthEventLogIn>((event, emit) async {
      //
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText:
              'Por favor, espera mientras se carga la pantalla de inicio',
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
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
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

          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );

    // Cuando el usuario quiere registrarse desde login
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(exception: null, isLoading: false));
      },
    );

    // Envío de reset de contraseña
    on<AuthEventForgotPassword>(
      (event, emit) async {
        // 1. El usuario hizo clic en el botón para recuperar su contraseña
        // y se debe mostrar la pantalla correspondiente.
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));

        final email = event.email;
        if (email == null) {
          // En este caso, al no haber un email, el usuario simplemente quiere
          // ir a la pantalla para recuperar contraseña.
          return;
        }

        // En este caso, el usuario Sí quiere enviar un correo para recuperar su
        // contraseña. Mostrar la pantalla de carga.
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ));

        bool didSendEmail;
        Exception? exception;

        // Intentar enviar el email para recuperar password.
        try {
          await provider.enviarPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }

        // Emitir un estado donde se envíe la exccepción (si se lanzó alguna),
        // la variable de identificación si el correo fue enviado e indicar
        // que ya no se está cargando nada.
        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ));
      },
    );
  }
}
