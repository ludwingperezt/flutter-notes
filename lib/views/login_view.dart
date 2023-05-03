// Atajo: Para crear un StatelessWidget, solo teclear stl y seleccionar el tipo
// de widget a crear (Stateless o Stateful)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:developer' as devtools show log;
import 'package:mynotes/dialogs/error_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
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
          if (state.exception is UserNotFoundAuthException) {
            await mostrarErrorDialog(
              context,
              context.loc.impossible_find_user,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await mostrarErrorDialog(
              context,
              context.loc.invalid_credentials,
            );
          } else if (state.exception is GenericAuthException) {
            await mostrarErrorDialog(
              context,
              context.loc.authentication_error,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.login),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  context.loc.access_account,
                ),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: context.loc.enter_email,
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: context.loc.enter_password,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // Aqui vamos a crear el usuario en firebase.
                    final email = _email.text;
                    final password = _password.text;

                    // Aqui sucede el evento de login el cual es enviado a AuthBloc
                    // para que genere un estado consecuente con ese evento.
                    context
                        .read<AuthBloc>()
                        .add(AuthEventLogIn(email, password));
                  },
                  child: Text(context.loc.access_account),
                ),
                TextButton(
                  onPressed: () {
                    // Aquí se manda a mostrar la view para solicitar la recuperación
                    // de contraseña.
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                  },
                  child: Text(context.loc.forgot_password),
                ),
                TextButton(
                  onPressed: () {
                    // Aquí se manda a mostrar la view para registrar pero se hace
                    // a través de AuthBloc y no manualmente como estaba antes.
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  child: Text(context.loc.register_here),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
