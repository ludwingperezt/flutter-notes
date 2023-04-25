/// Excepciones de autenticación
///

// Excepciones de login

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Excepciones de registro

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Excepciones genéricas

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
