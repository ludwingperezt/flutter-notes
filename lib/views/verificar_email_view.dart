import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

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
      body: SingleChildScrollView(
        child: Column(children: [
          const Text(
              'Hemos enviado un email a tu dirección para confirmar tu registro. Por favor abre el correo y haz clic en el enlace que recibiste para confirmar tu registro.'),
          const Text(
              'Si no has recibido el correo de verificación revisa en spam, si aún así no recibes el correo, haz clic en el botón de abajo'),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
            },
            child: const Text('Enviar email de vefificación'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            },
            child: const Text('Reiniciar'),
          )
        ]),
      ),
    );
  }
}
