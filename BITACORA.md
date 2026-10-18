# Bitácora de aprendizaje - Semana 14
**Estudiante:** Franklin Rivas

## Sesión 1: Programación asíncrona en Dart

### Práctica 1.3: Orden de ejecución

**Objetivo:** Comprender el orden de ejecución del código síncrono, las microtareas y la cola de eventos en Dart.

**Resultado obtenido:**

```text
A. inicio de main
E. fin de main
C. microtarea
B. evento (cola de eventos)
D. temporizador de 0 ms
```

**Análisis:**

Primero se ejecuta el código síncrono, por eso aparecen los mensajes A y E. Después se procesa la microtarea C. Finalmente, aparecen el evento B y el temporizador D.

**Conclusión:** Aprendí que Dart ejecuta primero las instrucciones síncronas y después procesa las tareas asíncronas. Las microtareas pendientes se procesan antes que los eventos pendientes.

### Práctica 1.6: Await olvidado

**Objetivo:** Comprender la importancia de utilizar await al ejecutar funciones asíncronas que pueden generar errores.

**Resultado inicial:**
¡Listo!
Unhandled exception: Exception: Título vacío

**Corrección realizada:**
Se agregó await a la llamada guardarTarea('') dentro del bloque try.

**Resultado final:**
Error controlado: Exception: Título vacío

**Análisis:**
Sin await, el programa no espera a que termine la operación asíncrona y el error no se captura correctamente mediante try/catch. Al agregar await, el programa espera el resultado y permite que catch controle la excepción.

**Conclusión:**
Aprendí que await permite esperar una operación asíncrona y capturar sus errores mediante try/catch.

### Práctica 1.7: Futures independientes

**Objetivo:** Comprender cómo ejecutar tareas asíncronas independientes de forma secuencial y concurrente.

**Resultado obtenido:**

```text
Secuencial: 5 s -> Ana, 7
Concurrente: 3 s -> Ana, 7
```

**Análisis:**

La ejecución secuencial tardó 5 segundos porque las operaciones se realizaron una después de otra. La ejecución concurrente tardó 3 segundos porque las tareas independientes pudieron avanzar al mismo tiempo.

**Conclusión:**

Aprendí que ejecutar tareas asíncronas independientes de forma concurrente puede reducir el tiempo total de espera. Sin embargo, cuando una tarea necesita el resultado de otra, primero debo esperar a que esa información esté disponible.

## Práctica 1.8: Experimento con Isolates

### Resultados obtenidos

| Prueba | Resultado | Tiempo | Observación |
|---|---|---|---|
| Sin isolate | 1199999997 | 13900 ms (13.9 segundos) | El cálculo se ejecutó en el hilo principal y la interfaz pudo bloquearse temporalmente. |
| Con isolate | Error de compatibilidad | No disponible | Chrome indicó que dart:isolate no está soportado en Dart para Web. La prueba queda pendiente en una plataforma compatible. |

### Análisis

En esta práctica comprobé la diferencia entre ejecutar una operación pesada en el hilo principal y ejecutarla mediante un isolate. La prueba sin isolate devolvió el resultado 1199999997 en 13900 milisegundos. Al ejecutar la prueba con isolate en Chrome, se produjo un error porque Dart para Web no admite esta operación. Por esta razón, la comparación de tiempos queda pendiente de realizarse en una plataforma compatible. En general, los isolates permiten ejecutar cálculos independientes del hilo principal y ayudan a mantener la interfaz más fluida.

## Sesión 2: Consumo de APIs REST

### Implementación de TareasApi

**Objetivo:** Practicar las solicitudes HTTP y la conversión de respuestas JSON a objetos Dart.

**Implementación realizada:**
- Se agregó el paquete `http` al proyecto.
- Se creó el servicio `lib/datos/tareas_api.dart`.
- Se implementó la consulta GET para obtener tareas desde JSONPlaceholder.
- Se implementó la creación POST de tareas.
- Se agregó un límite de espera de 10 segundos.
- Se controlaron errores de conexión, respuestas HTTP y datos JSON inválidos.
- Se creó `lib/estado/tareas_remotas_provider.dart` para administrar el estado asíncrono con Riverpod.
- Se integró una pantalla para consultar las tareas remotas.

**Resultado obtenido:**

La aplicación permitió consultar tareas de la API y probar la creación de una tarea. JSONPlaceholder simula la creación mediante POST; por tanto, la tarea creada no queda almacenada permanentemente en ese servidor.

### Pruebas automatizadas de errores

**Archivo:** `test/tareas_api_test.dart`

Se implementaron cuatro pruebas:

| Prueba | Resultado |
|---|---|
| Respuesta HTTP 500 | Aprobada |
| JSON inválido | Aprobada |
| Error de conexión | Aprobada |
| Tiempo de espera | Aprobada |

**Evidencia de ejecución:**

`flutter test test/tareas_api_test.dart`

Resultado: `+4: All tests passed!`

**Pruebas generales:**

`flutter test`

Resultado: `+19: All tests passed!`

### Análisis estático

Se ejecutó el comando `flutter analyze`. El analizador reportó tres avisos informativos relacionados con los nombres de archivos de prácticas anteriores. No se reportaron errores en el resultado mostrado.

### Revisión del modelo JSON con apoyo de IA

Se revisó el modelo `Tarea` y su método `fromJson` para convertir los datos recibidos en objetos Dart.

El modelo comprueba que el título recibido sea una cadena no vacía. También comprueba los tipos de los campos identificador y estado de completado antes de asignarlos.

**Decisión:** conservar estas comprobaciones para evitar aceptar datos con tipos incorrectos. Las pruebas automatizadas registradas en esta sesión se centran en los errores de comunicación y en el formato de la respuesta HTTP; no deben confundirse con pruebas unitarias exhaustivas de todos los casos límite de `Tarea.fromJson`.

### Conclusión de la sesión

Aprendí a separar la comunicación HTTP de la interfaz, convertir respuestas JSON en objetos Dart, administrar estados asíncronos con Riverpod y controlar errores de red y de formato. Las pruebas automatizadas confirmaron el funcionamiento de los cuatro escenarios de error y las 19 pruebas generales del proyecto.
