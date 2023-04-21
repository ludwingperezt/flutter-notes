import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        const Text('Verifica tu direccion de correo electronico'),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Enviar email de vefificación'))
      ]),
    );
  }
}
