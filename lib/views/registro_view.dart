import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/dialogs/show_error_dialog.dart';

// Widget para registro de nuevos usuarios.
class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
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
    // Scaffold() agrega todos los componentes del widget.
    // El widget Column se usa para apilar componentes, en este caso
    // se apilan los campos de usuario, contraseña y botón de registro
    // en una sola columna.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
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
                final userCredentials =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                // Una vez que el registro es exitoso se envía el email para
                // confirmar la dirección de correo sin que el usuario tenga
                // que hacerlo manualmente.
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();

                // En este caso se usa pushNamed y no pushNamedAndRemoveUntil
                // porque no queremos que las vistas anteriores sean destruidas
                // en caso de que el usuario quiera retornar a la vista de registro
                // y corregir datos.
                if (context.mounted) {
                  Navigator.of(context).pushNamed(verificarEmailRoute);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  devtools.log('Contraseña debil');
                  await mostrarErrorDialog(
                    context,
                    'Contraseña debil',
                  );
                  // print('Weak password!');
                } else if (e.code == 'email-already-in-use') {
                  devtools.log('Email en uso');
                  await mostrarErrorDialog(
                    context,
                    'Email en uso',
                  );
                  // print('Email already in use!');
                } else if (e.code == 'invalid-email') {
                  // print('Email in invalid!');
                  devtools.log('Email invalido');
                  await mostrarErrorDialog(
                    context,
                    'Email no válido',
                  );
                } else {
                  devtools.log(e.toString());
                  // print(e);
                  await mostrarErrorDialog(
                    context,
                    'Error: ${e.code}',
                  );
                }
              } catch (e) {
                devtools.log(e.toString());
                // print(e);
                await mostrarErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Registrarse'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Ya te has registrado? Login aqui!'),
          )
        ],
      ),
    );
  }
}
