# Analizador léxico de miniLang

## Integrantes

Completar antes de entregar: nombres y apellidos de todos los integrantes del grupo.

## Expresiones regulares

Las definiciones `digito` y `letra` sirven de base. Un identificador comienza por letra o `_` y continúa con letras, dígitos o `_`. Las palabras reservadas aparecen antes que el patrón de identificador, por lo que Flex las selecciona como palabras reservadas cuando ambos patrones tienen la misma longitud.

Los enteros contienen uno o más dígitos. Los reales admiten una parte decimal con dígitos a ambos lados del punto, o notación científica con exponente `e`/`E`, signo opcional y uno o más dígitos. Una forma decimal también puede llevar exponente. Las cadenas empiezan y terminan con comillas dobles y no admiten saltos de línea.

Los operadores de dos caracteres se colocan antes que los de uno. La potencia `**` se escribe como `POTENCIA_DOBLE`; los demás operadores y separadores se escriben mediante su propio lexema.

## Validación incremental de patrones

Los patrones se comprobaron por etapas: primero palabras reservadas e identificadores; después enteros; a continuación reales decimales y científicos; luego operadores y separadores; finalmente cadenas, comentarios y patrones erróneos. Se comprobó especialmente la ambigüedad `2E6`: el patrón real válido debe aparecer antes que las reglas de número mal formado cuando ambos reconocen la misma longitud. También se comprobó que `5e+`, `1.2.3`, `.75` y `12abc` generan un único error cada uno.

## Tratamiento de comentarios

El comentario `//` consume todos los caracteres hasta el salto de línea, que se procesa por la regla normal para contarlo. Al reconocer `/*`, el analizador entra en el estado exclusivo `COMENTARIO`. En ese estado ignora el contenido, cuenta sus saltos de línea y vuelve a `INITIAL` al encontrar `*/`. Si llega al final del fichero, informa del número de línea en el que comenzó el comentario sin cerrar.

## Control del número de línea

La variable obligatoria `acumula_saltos_ml` empieza en 1 y se incrementa con cada `LF`, `CRLF` o `CR`, también dentro de comentarios multilínea. Para presentar el número físico de líneas, no se cuenta una línea vacía adicional cuando el fichero termina en salto de línea. Los errores usan el valor actual; el comentario sin cerrar conserva además su línea inicial.

## Errores léxicos

Se detectan caracteres no reconocidos, cadenas sin cerrar, comentarios multilínea sin cerrar y varias formas de constante numérica mal formada. Cada diagnóstico se envía a la salida de error, indica una línea y termina exactamente en `[ML-7Q]`. Los tokens reconocidos se siguen guardando en `tokens.txt`.

## Compilación y uso

En un sistema con Flex y GCC:

```text
make test
```

El ejecutable recibe exactamente un fichero `.min`. Los objetivos de `make` lo ejecutan desde `output/`, por lo que el resultado queda en `output/tokens.txt`.

## Pruebas

- `todos_tokens.min`: todas las palabras reservadas, identificadores, tipos de constantes, operadores y separadores.
- `comentarios_cadenas.min`: ambos comentarios y cadenas con espacios y símbolos.
- `errores.min`: número seguido de letras, doble punto, exponente incompleto, decimal sin parte entera, cadena sin cerrar y carácter desconocido.
- `comentario_sin_cerrar.min`: final de fichero dentro de un comentario multilínea.

Flex 2.6.4 generó el C sin errores. El C generado se compiló y ejecutó con TinyCC porque el entorno disponible no tenía GCC y su instalación agotó el pequeño disco de WSL. Las cuatro pruebas terminaron correctamente: 23, 8, 8 y 4 líneas, respectivamente; las pruebas válidas no emitieron errores y las inválidas emitieron los errores esperados con líneas correctas y el sufijo obligatorio.

## Uso de inteligencia artificial

Se utilizó OpenAI Codex como apoyo para leer y contrastar el enunciado y los apuntes, preparar y revisar `minilang.l`, diseñar los cuatro ficheros de prueba, ejecutar Flex y las pruebas, corregir la precedencia de los patrones científicos y redactar estas notas. El código del analizador, los casos de prueba, `tokens.txt` y estas notas fueron creados o modificados con su ayuda. La comprobación realizada incluyó generación con Flex, compilación del C generado, ejecución de todos los casos, inspección de tokens, recuentos de líneas y diagnósticos. Antes de entregar, los integrantes deben revisar cada regla, repetir la compilación con GCC en su equipo y poder explicar las decisiones durante una defensa.

## Supuestos

El enunciado no fija cómo seleccionar la entrada ni dónde imprimir los errores. Se eligió recibir el nombre del fuente como primer argumento, escribir siempre los tokens en `tokens.txt` y enviar los diagnósticos a `stderr`. Tampoco define escapes dentro de cadenas; por ello las comillas delimitan la cadena y no se implementan secuencias de escape.
