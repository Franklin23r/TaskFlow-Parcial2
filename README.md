# TaskFlow — Parcial 2

Aplicación desarrollada con Flutter y Dart para la asignatura Desarrollo de Aplicaciones Móviles.

## Funcionalidades

- Inicio de sesión con validación de correo y contraseña.
- Registro con nombre, correo, contraseña, confirmación y aceptación de términos.
- Navegación entre Login, Registro y Listado.
- Consulta de publicaciones desde una API REST pública.
- Paginación automática al desplazarse por la lista.
- Estados de carga, error, reintento y lista vacía.
- Actualización manual de publicaciones.
- Cierre de sesión.

## Tecnologías utilizadas

- Flutter y Dart.
- Riverpod para el manejo del estado.
- HTTP para las solicitudes a la API.
- JSONPlaceholder como API pública de publicaciones.
- Material Design.

## Estructura principal

```text
lib/
├── datos/
│   └── publicaciones_api.dart
├── estado/
│   └── publicaciones_provider.dart
├── modelos/
│   └── publicacion.dart
├── pantallas/
│   ├── login_screen.dart
│   ├── registro_screen.dart
│   └── listado_screen.dart
└── widgets/
    └── campo_formulario.dart
```

## Cómo ejecutar el proyecto

Se necesita Flutter instalado y conexión a Internet para consultar las publicaciones.

Desde PowerShell, dentro de la carpeta del proyecto:

```powershell
flutter pub get
flutter run
```

Para analizar el código:

```powershell
flutter analyze
```

## Capturas de pantalla

Pendiente de agregar las capturas reales de Login, Registro y Listado.

## Diseños de Google Stitch

- Enlace público del proyecto: pendiente.
- Diseño de Login: pendiente.
- Diseño de Registro: pendiente.
- Diseño de Listado: pendiente.
- Prompt utilizado: pendiente.

## Uso de inteligencia artificial

Se utilizó ChatGPT como apoyo durante el desarrollo y la documentación. La entrega debe especificar qué código se generó con ayuda de inteligencia artificial, qué partes se aceptaron o modificaron y qué sugerencias se descartaron, según el trabajo realizado.

## Repositorio de GitHub

https://github.com/Franklin23r/TaskFlow-Parcial2
