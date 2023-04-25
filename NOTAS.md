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