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

Estas reglas se actualizaron para mayor seguridad, quedando así:
* Se permite leer, actualizar y eliminar solo a los usuarios con sesión activa
  y que sean los propietarios de las notas.
* Se permite crear notas a los usuarios con sesión activa. 

```  
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, update, delete: if request.auth != null && request.auth.uid == resource.data.user_id;
      allow create: if request.auth != null;
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

```  
flutter pub add share_plus
```  

* Luego de agregar un nuevo plugin al proyecto se recomienda hacer un clean and
  rebuild, ya que flutter usa CocoaPods para manejar iOS dependencies y algunas
  veces no reconoce las nuevas dependencias (para android no suele ser un 
  problema pero igual se recomienda hacerlo):

```  
  flutter clean
  flutter clean android
  flutter pub get
```  

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

* BlocConsumer: Combina BlocListener y un BlocBuilder. Permite hacer ambas cosas
  al mismo tiempo.

** Las clases que deriven de una clase abstracta y que tengan constructor const,
   la clase abstracta también deberá tener un constructor const.

### Equality

En algunos casos como en el estado AuthStateLoggedOut aunque de manera externa
el estado puede ser el mismo, de manera interna no siempre es el caso, ya que
una misma instancia de la misma clase puede representar distintas cosas en base
a los valores de las variables que tiene instanciadas.

Para hacer esa diferenciación se utiliza la librería equatable:

```  
flutter pub add equatable
```  

## Overlays

Son pantallas o componentes que se muestran sobre cualquier pantalla que esté
visible, independientemente de la pila de navegación (la pila de navegación
es una especie de historial en la cual se van apilando las pantallas o views
que el usuario va viendo). 

Por lo regular se usan para mostrar loading screens.

## Iconos

[Sitio para encontrar íconos](https://www.stockio.com/)
[Sitio para generar íconos en distintos tamaños](https://www.appicon.co/)

Para agregar íconos a la app se usa el plugin flutter_launcher_icons  

```  
flutter pub add flutter_launcher_icons
```  

### Generar los íconos:

```  
flutter pub run flutter_launcher_icons
```  

## Tomar capturas de pantalla con adb y emuladores

Se puede usar cualquiera de los dos comandos siguientes: 

```  
adb exec-out screencap -p > /path/al/archivo/captura.png
```  

o este otro (-e es para usar conexión TCP/IP):

```  
adb -e exec-out screencap -p > /path/al/archivo/captura.png
```  

## Internacionalización

Para manejar varios idiomas en una app de flutter es necesario seguir las instrucciones
de la documentación oficial de flutter para i10n:

[Internationalizing Flutter apps](https://docs.flutter.dev/accessibility-and-localization/internationalization)

En resumen, lo que se hace para internacionalizar una app es:

1.  Instalar los plugins de internacionalización

2.  Crear el archivo l10n.yaml en la raíz del proyecto y definir en ese archivo
    el directorio donde se ubicarán las cadenas de texto y las traducciones
    y el idioma principal de la aplicación.  También se especifica el nombre
    del archivo de salida de las traducciones.

3.  Crear el directorio configurado para almacenar los archivos .arb que contienen
    los textos de traducción.  

4.  Crear los archivos .arb para cada idioma soportado.
    Estos archivos son creados en la carpeta que se defina en el archivo l10n.yaml,
    pero regularmente se colocan en la carpeta ```lib/l10n```.
    Los archivos .arb son archivos json donde cada 
    clave corresponde a un texto a mostrar al usuario y al que luego se puede
    referenciar en el código.  También pueden contener una sintaxis especial
    con código para definir las pluralizaciones.
    Todos los archivos .arb que existan deben tener las mismas keys pero con los
    textos en el idioma que corresponda a cada archivo.

5.  En el caso de una app para iOS es necesario definir los idiomas a manejar.
    Para android esto se hace de forma automática.
    Esta definición de idiomas se hace en el archivo:
    ```ios/Runner/Info.plist```
    En el cual se agrega la key **CFBundleLocalizations** la cual es una lista
    con los códigos cortos de idiomas los idiomas que se manejan.

6.  Para que los textos y traducciones estén disponibles en los archivos que 
    definen las vistas, es necesario recompilar el proyecto.  Esto se hace 
    haciendo hot-restart de la aplicación cada vez que los archivos .arb cambian.
    La salida del proceso de compilación de los archivos de traducciones se 
    coloca en la path:
    ```.dart_tool/flutter_gen/gen_l10n```
    En el archivo de salida app_localizations.dart que se encuentra dentro de
    ese directorio se encuentra una clase que puede ser referenciada desde el 
    código para obtener los textos y mostrarlos a los ususarios en los widgets
    que correspondan.

    También es necesario declarar el soporte de internacionalización en el archivo
    main.dart, por medio de los parámetros "supportedLocales" y 
    "localizationsDelegates" del constructor del objeto MaterialApp.

7.  En los archivos de views, donde los textos son mostrados al usuario, para
    mostrar un texto en un widget en principio se haría lo siguiente:

    ``` 
    import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

    Text(AppLocalizations.of(this)!.my_text)
    ``` 

    Pero para tener un acceso más fácil al texto, lo recomendable es generar
    una extensión sobre BuildContext que sea un getter que retorne la clase
    AppLocalizations o que lance una excepción si no ésta no existe.
    (Ver la implementación de esta extensión en ```lib/extensions/buildcontext/loc.dart```)

    De esta manera, el acceso al texto se facilitaría como en el ejemplo siguiente:

    ``` 
    import 'package:mynotes/extensions/buildcontext/loc.dart';

    Text(context.loc.my_text)
    ``` 

8.  Para mostrar pluralizaciones es necesario definir la función que decida 
    cómo mostrar cada texto según un número enviado como parámetro.  La implementación
    de esto se puede ver en los archivos .arb ubicados en ```lib/l10n```
    en la key "notes_title", la cual define como mostrar el título de la página
    de notas según si hay 0, 1 o más notas.
    En el archivo ```lib/views/notas_view.dart``` se definió en el title del
    appBar, un StreamBuilder que retorne la cantidad de notas obtenidas en el 
    momento que hayan datos disponibles.  Esa cantidad es enviada a la clase 
    AppLocalizations en la función ```notes_title()``` para que retorne la 
    pluralización adecuada.  Sin embargo, es necesario crear un extension agregado
    a un Stream, el cual retorne la cantidad de elementos del Iterable que forma
    parte del Stream. (Ver la implementación de ese extension al inicio del archivo
    ```lib/views/notas_view.dart```).

## Enlaces de interés

[Build and release an Android app](https://docs.flutter.dev/deployment/android)
[Adding a splash screen to your Android app](https://docs.flutter.dev/platform-integration/android/splash-screen)
[Flutter - Cloud Firestore](https://firebase.flutter.dev/docs/firestore/usage/)
[Navigate with named routes](https://docs.flutter.dev/cookbook/navigation/named-routes)
[Using Firebase Authentication](https://firebase.flutter.dev/docs/auth/usage/)
[Internationalizing Flutter apps](https://docs.flutter.dev/accessibility-and-localization/internationalization)

### Librerías utilizadas
[share_plus](https://pub.dev/packages/share_plus)
[flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
