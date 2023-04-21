import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        // FutureBuilder se usa para inicializar un widget HASTA que una promesa se haya completado, en este caso hasta que la app Firebase se haya iniciado.
        builder: (context, snapshot) {
          // a través de snapshot se puede obtener el estado de la promesa (Future)
          // y realizar alguna acción mientras se espera que se resuelva y cuando
          // se reciba una respuesta, ya sea exitosa o sea un error.

          switch (snapshot.connectionState) {
            // TODO: Pendiente de implementar los otros casos de estado del Future
            // case ConnectionState.none:
            //   // TODO: Handle this case.
            //   break;
            // case ConnectionState.waiting:
            //   // TODO: Handle this case.
            //   break;
            // case ConnectionState.active:
            //   // TODO: Handle this case.
            //   break;

            case ConnectionState.done:
              // El widget Column se usa para apilar componentes, en este caso
              // se apilan los campos de usuario, contraseña y botón de registro
              // en una sola columna.
              return Column(
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
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('Weak password!');
                        } else if (e.code == 'email-already-in-use') {
                          print('Email already in use!');
                        } else if (e.code == 'invalid-email') {
                          print('Email in invalid!');
                        } else {
                          print(e);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('Registrarse'),
                  ),
                ],
              );

            default:
              return const Text('Cargando...');
          }
        },
      ),
    );
  }
}
