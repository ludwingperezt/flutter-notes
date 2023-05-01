## Crear un nuevo proyecto de flutter:  
``` 
flutter create --org com.example appname
``` 

## Carpetas y archivos de un proyecto flutter

En la carpeta ios/ se colocan todos los archivos para ejecutar la aplicación en
un ambiente iOS.

En la carpeta test/ se ubican los tests de la app.

En la carpeta android/ se colocan todos los archivos para crear una aplicación
para android.

La carpeta web/ contiene los archivos para crear una aplicación web.

## Para agregar nuevas dependencias:
```  
flutter pub add <nombre del paquete>
```

## Herramientas recomendadas para desarrollo android

* Scrcpy - https://github.com/Genymobile/scrcpy
* ADB (Android Debug Bridge -Se usa para enviar comandos al dispositivo-)
    android-platform-tools
* Activar USB debugging en el teléfono para poder usar Scrcpy y ADB

## Comandos útiles
flutter clean android

flutter pub get

## Conectar con firebase

Para conectar el proyecto con firebase es necesario instalar dos herramientas
CLI:
* firebase cli
* flutterfire

Una vez instaladas, es necesario ir a la consola de Google Cloud Platform (si
es que no se ha hecho antes) y aceptar los términos y condiciones del servicio
(nada más).

Luego hay que crear un proyecto en la consola web de firebase.

Posterior a esto ya se puede usar el comando siguiente para configurar el proyecto
de firebase tanto en el backend como en el proyecto de flutter:
flutterfire configure

https://stackoverflow.com/questions/57145441/solution-google-cloud-sdk-issue-callers-must-accept-terms-of-service
https://stackoverflow.com/questions/72471732/firebaseerror-http-error-403-the-caller-does-not-have-permission

## Seguridad de las API keys de firebase

https://hanskokx.medium.com/securing-your-firebase-credentials-in-your-flutter-app-and-git-repository-4080fead7968
https://blog.mbonnin.net/about-the-android-makers-app-security-and-google-servicesjson

## Para usar un menú en un AppBar

1. Es necesario un enum donde se listan las acciones a presentar en el menú
2. Definir PopupMenuButton (botón principal de acceso al menú) y PopupMenuItem
   (Cada elemento del menú).

## Testing

Existen tres tipos de tests para una aplicación flutter  

- Unit tests
- Integration tests
- Widget tests

Para hacer testing de una app es necesario instalar las dependencias de testing:
```  
flutter pub add test --dev
```  

Para correr tests:
```  
flutter test <path del archivo de tests a ejecutar>
```  

## Dependencias para manejar base de datos SQLite

flutter pub add sqflite path_provider path

## StreamController

Se usa un StreamController para mantener una caché de datos en memoria la cual
es la fuente de verdad de datos para la UI.  Cuando hay un cambio en los datos,
se actualiza la DB y también se actualiza el StreamController, y la UI al ser
notificada de cambios en el StreamController se actualiza también.

El StreamController necesita un objeto subyacente para funcionar, por ejemplo
en el caso de listas de elementos, el objeto subyacente puede ser una lista
o un iterable.

## FutureBuilder y AsyncSnapshot

FutureBuilder es un StatefulWidget que enlaza la lógica con la UI. Permite 
ejecutar la construcción de widgets mientras se recibe la respuesta de un Future
al cual se suscribe.

AsyncSnapshot envuelve una funcionalidad asíncrona y permite recibir 
actualizaciones.

## Configurar Firestore

[Configuración de Firestore](https://youtu.be/VPvVD8t02U8?t=85965)

Reglas provisionales de permisos para la base de datos firestore (Esta regla
no es muy segura porque da acceso a toda la base de datos a cualquier usuario
que esté loggeado):
```  
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```  

[Acerca de las colecciones](https://youtu.be/VPvVD8t02U8?t=86428)

[Documentos y colecciones](https://youtu.be/VPvVD8t02U8?t=86635)

## Compartir notas con otros usuarios

El plugin share-plus extiende la funcionalidad de flutter. Lo que hace es permitir
compartir contenido desde la app (hecha en flutter) a través del dialog
de compartir de la plataforma nativa.

https://pub.dev/packages/share_plus

flutter pub add share_plus

* Luego de agregar un nuevo plugin al proyecto se recomienda hacer un clean and
  rebuild, ya que flutter usa CocoaPods para manejar iOS dependencies y algunas
  veces no reconoce las nuevas dependencias (para android no suele ser un 
  problema pero igual se recomienda hacerlo):

  flutter clean
  flutter clean android
  flutter pub get

## Bloc

Es una librería que se usa para separar la presentación de la lógica de negocio.

Bloc se divide en dos:
* Bloc -- Es la parte que se ocupa de la lógica de negocio
* flutter_block -- es la parte que se encarga de la presentación, la cual está
    relacionada con flutter.

### Elementos de Bloc

* Bloc class: Es un contenedor que puede contener eventos que producen estados.
    La clase bloc comienza con un estado y sus salidas son estados.

            Event -> Bloc -> State

* BlocProvider: Es una clase que crea una instancia de Bloc.

* BlocListener: Escucha cambios en el estado de bloc. Ideal para efectos secundarios
  como mostrar dialogs mientras otras operaciones se realizan.

* BlocBuilder: Usa los cambios del estado de bloc para generar Widgets.

* BlocConsumer: Combina BlocListener y un BlocBuilder



** Las clases que deriven de una clase abstracta y que tengan constructor const,
   la clase abstracta también deberá tener un constructor const.