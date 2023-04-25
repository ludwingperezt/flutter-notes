import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerificarEmailView extends StatefulWidget {
  const VerificarEmailView({super.key});

  @override
  State<VerificarEmailView> createState() => _VerificarEmailViewState();
}

class _VerificarEmailViewState extends State<VerificarEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar email'),
      ),
      body: Column(children: [
        const Text(
            'Hemos enviado un email a tu dirección para confirmar tu registro. Por favor abre el correo y haz clic en el enlace que recibiste para confirmar tu registro.'),
        const Text(
            'Si no has recibido el correo de verificación revisa en spam, si aún así no recibes el correo, haz clic en el botón de abajo'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('Enviar email de vefificación'),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();

            if (context.mounted) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registroRoute, (route) => false);
            }
          },
          child: const Text('Reiniciar'),
        )
      ]),
    );
  }
}
