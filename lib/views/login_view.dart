// Atajo: Para crear un StatelessWidget, solo teclear stl y seleccionar el tipo
// de widget a crear (Stateless o Stateful)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
                final userCredentials = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);

                // print(userCredentials);
                devtools.log(userCredentials.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                } else if (e.code == 'wrong-password') {
                  // print('Wrong pass');
                  devtools.log('Contraseña incorrecta');
                } else {
                  devtools.log(e.toString());
                  //print(e);
                }
              } catch (e) {
                devtools.log(e.toString());
                //print(e);
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
                '/registro/',
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
