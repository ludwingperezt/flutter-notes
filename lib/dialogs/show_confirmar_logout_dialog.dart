// import 'package:flutter/material.dart';

// /// Modal que sirve para confirmar el cierre de la sesión
// Future<bool> mostrarLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Salir'),
//         content: const Text('Está seguro de cerrar sesión?'),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 // Indicar que el usuario canceló el modal
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Cancelar')),
//           TextButton(
//               onPressed: () {
//                 // Indicar que el usuario confirmó el cierre de la sesión
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('Log out')),
//         ],
//       );
//     },
//   ).then((value) =>
//       value ??
//       false); // esta línea es para especificar un valor de retorno cuando el usuario descarta el popup con el botón "Atras" o cuando hace clic en la pantalla para cerrar el diálogo.
// }
