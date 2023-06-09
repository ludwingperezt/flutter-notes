import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/dialogs/error_dialog.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
                await AuthService.firebase().crearUsuario(
                  email: email,
                  password: password,
                );

                await AuthService.firebase().enviarEmailVerificacion();

                // En este caso se usa pushNamed y no pushNamedAndRemoveUntil
                // porque no queremos que las vistas anteriores sean destruidas
                // en caso de que el usuario quiera retornar a la vista de registro
                // y corregir datos.
                if (context.mounted) {
                  Navigator.of(context).pushNamed(verificarEmailRoute);
                }
              } on WeakPasswordAuthException {
                await mostrarErrorDialog(
                  context,
                  'Contraseña debil',
                );
              } on EmailAlreadyInUseAuthException {
                await mostrarErrorDialog(
                  context,
                  'Email en uso',
                );
              } on InvalidEmailAuthException {
                await mostrarErrorDialog(
                  context,
                  'Email no válido',
                );
              } on GenericAuthException {
                await mostrarErrorDialog(
                  context,
                  'Fallo al registrar usuario',
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
