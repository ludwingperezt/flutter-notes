// Atajo: Para crear un StatelessWidget, solo teclear stl y seleccionar el tipo
// de widget a crear (Stateless o Stateful)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/dialogs/error_dialog.dart';
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
    return Scaffold(
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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              // Aqui se manejan las excepciones

              if (state is AuthStateLoggedOut) {
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
            child: TextButton(
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
          ),
          TextButton(
            onPressed: () {
              // Lo que estamos haciendo aquí es remover la pantalla anterior
              // y colocar una nueva, que correspondería a la pantalla de registro.
              // Es necesario que la pantalla que se va a colocar sea un Scaffold
              // completo.
              Navigator.of(context).pushNamedAndRemoveUntil(
                registroRoute,
                (route) => false,
              );
            },
            child: Text('Regístrate aquí!'),
          )
        ],
      ),
    );
  }
}
