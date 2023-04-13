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