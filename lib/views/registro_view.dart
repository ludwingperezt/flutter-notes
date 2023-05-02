import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/dialogs/error_dialog.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // Manejar aquí las excepciones que se pueden presentar cuando se
        // hace el proceso de registro.

        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await mostrarErrorDialog(
              context,
              'Contraseña debil',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await mostrarErrorDialog(
              context,
              'Email en uso',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await mostrarErrorDialog(
              context,
              'Email no válido',
            );
          } else if (state.exception is GenericAuthException) {
            await mostrarErrorDialog(
              context,
              'Fallo al registrar usuario',
            );
          }
        }
      },
      child: Scaffold(
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

                // Desencadenar el evento de Registro pero a través de AuthBloc
                context.read<AuthBloc>().add(
                      AuthEventRegister(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                // Al hacer clic en este botón se debe mostrar la pantalla de login
                // y eso se puede hacer enviando el evento de logout al AuthBloc
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Ya te has registrado? Login aqui!'),
            )
          ],
        ),
      ),
    );
  }
}
