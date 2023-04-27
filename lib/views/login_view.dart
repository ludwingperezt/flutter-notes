// Atajo: Para crear un StatelessWidget, solo teclear stl y seleccionar el tipo
// de widget a crear (Stateless o Stateful)
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/dialogs/error_dialog.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
          TextButton(
            onPressed: () async {
              // Aqui vamos a crear el usuario en firebase.
              final email = _email.text;
              final password = _password.text;

              try {
                final userCredentials = await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                // print(userCredentials);
                devtools.log(userCredentials.toString());

                final user = AuthService.firebase().currentUser;

                if (user?.isEmailVerified ?? false) {
                  // Ir a la pantalla principal del usuario loggeado
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notasRoute,
                      (route) => false,
                    );
                  }
                } else {
                  if (context.mounted) {
                    // Si la cuenta no ha verificado su email, entonces
                    // enviar al usuario a la pantalla de confirmación de email.
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verificarEmailRoute,
                      (route) => false,
                    );
                  }
                }
              } on UserNotFoundAuthException {
                await mostrarErrorDialog(
                  context,
                  'Usuario no encontrado',
                );
              } on WrongPasswordAuthException {
                devtools.log('Contraseña incorrecta');
                await mostrarErrorDialog(
                  context,
                  'Credenciales no válidas',
                );
              } on GenericAuthException {
                // devtools.log(e.toString());
                await mostrarErrorDialog(
                  context,
                  'Error de autenticación',
                );
              }
            },
            child: const Text('Ingresar'),
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
