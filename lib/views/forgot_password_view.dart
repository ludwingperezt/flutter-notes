import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/dialogs/error_dialog.dart';
import 'package:mynotes/dialogs/password_reset_email_sent_dialog.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          // Si el mail de recuperación ya se envió entonces mostrar un dialog
          // que notifique que el email ya fue enviado.
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }

          // Si ocurrió algún error en el envío del mail de recuperación, entonces
          // se muestra un dialog con un mensaje de error.
          if (state.exception != null) {
            if (context.mounted) {
              await mostrarErrorDialog(
                context,
                context.loc.request_not_processed,
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.reset_password)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  context.loc.reset_password_notice,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  decoration:
                      InputDecoration(hintText: context.loc.enter_email_hint),
                ),
                TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: Text(context.loc.send_me_link_reset_password),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: Text(context.loc.back_to_login),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
