import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notas_view.dart';
import 'package:mynotes/views/registro_view.dart';
import 'package:mynotes/views/verificar_email_view.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    // En alguna parte del código hay que inicializar el Bloc. En la creación
    // del blocProvider en main.dart se hace una inyección del AuthBloc en el
    // context para que esté disponible en toda la aplicación.
    // Para leerlo solo hace falta hacer:
    // context.read<AuthBloc>()

    // Para hacer comunicación con el AuthBloc la única forma es enviar a través
    // del envío de eventos, y eso se hace con la función add()
    // Aquí estamos inicializando el bloc
    context.read<AuthBloc>().add(const AuthEventInitialize());

    // En este bloque se decide qué vista se hará render dependiendo del estado
    // que resulte de algún evento.
    return BlocConsumer<AuthBloc, AuthState>(
      // Debido a que en este punto es que se necesita mostrar u ocultar el dialog
      // de cargando, es necesario usar un BlocConsumer que combina un BlocListener
      // para reaccionar a cualquier cambio de estado que implique que se debe
      // mostrar u ocultar un diálogo de carga; y también un BlocBuilder para
      // mostrar la pantalla correspondiente según el estado.
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context, text: state.loadingText ?? context.loc.wait);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotasView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerificarEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegistroView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
