// Atajo: Para crear un StatelessWidget, solo teclear stl y seleccionar el tipo
// de widget a crear (Stateless o Stateful)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:developer' as devtools show log;
import 'package:mynotes/dialogs/error_dialog.dart';
import 'package:mynotes/dialogs/loading_dialog.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    // Iniciar los controladores de texto para el email y la contraseña
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    // SIEMPRE: Eliminar los controladores al finalizar la pantalla
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se quitó el Scaffold, porque la inicialización del AppBar es trabajo
    // de la vista de inicio (por ahora).
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // Aqui se manejan las excepciones

        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;

          // Esta condición significa: Si ya no estamos cargando nada, pero
          // estuvimos cargando antes; entonces lo que se hace es cerrar el dialog
          // que esté mostrándose.
          // Si por el contrario, por medio del estado sabemos que la app está
          // cargando (en espera de algo) y no hay un dialog mostrado, entonces
          // se muestra.
          // El retorno de la función para mostrar un diálogo de carga es una
          // función que sirve para cerrar ese diálogo.
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = mostrarCargandoDialog(
              context: context,
              text: 'Cargando...',
            );
          }

          if (state.exception is UserNotFoundAuthException) {
            await mostrarErrorDialog(
              context,
              'Usuario no encontrado',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await mostrarErrorDialog(
              context,
              'Credenciales no válidas',
            );
          } else if (state.exception is GenericAuthException) {
            await mostrarErrorDialog(
              context,
              'Error de autenticación',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Ingrese su email',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Ingrese su contraseña',
              ),
            ),
            TextButton(
              onPressed: () async {
                // Aqui vamos a crear el usuario en firebase.
                final email = _email.text;
                final password = _password.text;

                // Aqui sucede el evento de login el cual es enviado a AuthBloc
                // para que genere un estado consecuente con ese evento.
                context.read<AuthBloc>().add(AuthEventLogIn(email, password));
              },
              child: const Text('Ingresar'),
            ),
            TextButton(
              onPressed: () {
                // Aquí se manda a mostrar la view para registrar pero se hace
                // a través de AuthBloc y no manualmente como estaba antes.
                context.read()<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                    );
              },
              child: Text('Regístrate aquí!'),
            )
          ],
        ),
      ),
    );
  }
}
