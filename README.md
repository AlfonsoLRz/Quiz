![swift](https://img.shields.io/badge/swift-4.1.1-green.svg)
![xcode](https://img.shields.io/badge/xcode-9.3-green.svg)
![core-data](https://img.shields.io/badge/core%20data-3.2.0-green.svg)

# Quiz!
**Quiz!** es un **juego de preguntas y respuestas** desarrollado en Swift para la asignatura de Desarrollo de Sofware para Dispositivos Móviles en la Universidad de Jaén.

<p align="center">
  <img src="doc/Imágenes/Icono.png" width="300px" alt="Quiz! icon">
</p>

### Índice
[Cómo jugar](#cómo-jugar)<br>
[Cómo probar la aplicación](#cómo-probarlo)<br>

## Cómo jugar
**Quiz! permite realizar partidas con todas las preguntas de las que se compone tu base de datos**. Por defecto habrá dos preguntas para comenzar a jugar.

<p align="center">
  <img src="doc/Manual/Imágenes/Home.png" width="200px" alt="Home">
</p>

### Configuración

En el caso de que no haya preguntas no se podrá jugar una partida, y para ello habrá que acceder a la **configuración**, donde podemos gestionar nuestras preguntas.

<p align="center">
  <img src="doc/Manual/Imágenes/Edición.png" width="200px" alt="Configuración">
</p>

Al acceder a la configuración obtendremos una pantalla como la anterior, la cual tendrá dos modos de funcionamiento:
  * El **primer modo**, en el cual no se pueden gestionar las preguntas, **sólo consultarlas**.
  * Un **segundo modo** donde sí que podemos **añadir, eliminar y modificar preguntas** como aparece en la imagen anterior. Dentro de esta pantalla, las diferentes acciones y sus formas de acceso son:
    - **Añadir preguntas**, mediante el icono en la esquina derecha superior, que nos llevará a una vista como la siguiente:

    <p align="center">
      <img src="doc/Manual/Imágenes/Añadir.png" width="200px" alt="Añadir preguntas">
    </p>
    
    Todas las preguntas de Quiz! se componen de cuatro respuestas, de las cuales una será la verdadera. Además, podemos asociar las preguntas a categorías, de tal forma que al jugar podemos realizar partidas que sólo contengan preguntas de una determinada categoría.

    - **Eliminar preguntas**, desplazando una fila hacia la izquierda.
    - **Modificar preguntas** presionando en la fila en la que ésta se encuentra, lo que nos llevará a una vista similar a la de añadir preguntas.

### Desarrollo de partida

Una vez tenemos todas las preguntas que deseamos en nuestra base de datos, ¡podemos comenzar a jugar!

<p align="center">
  <img src="doc/Imágenes/EmojiFeliz.png" width="150px" alt="Cara feliz">
</p>

Como ya comentamos, **desde la pantalla principal se puede acceder a jugar una partida**. Nuestro primer paso antes de comenzar una partida será **elegir la categoría de las preguntas** que queremos que nos aparezcan:

<p align="center">
  <img src="doc/Manual/Imágenes/ElegirCategoría.png" width="200px" alt="Elegir categoría">
</p>

Una vez elegida, ¡comienza la partida!
Las preguntas aparecen de forma aleatoria, tanto el orden de preguntas como de las respuestas.

<p align="center">
  <img src="doc/Manual/Imágenes/Pregunta.png" width="200px" alt="Responder pregunta">
</p>

**¡Ojo! No podrás fallar ninguna pregunta para alcanzar la victoria**, por lo que si te equivocas en una...

<p align="center">
  <img src="doc/Imágenes/EmojiTriste.png" width="150px" alt="Cara triste">
</p>

Si aciertas, es posible que esto aún no haya terminado o... **¡que hayas ganado!**

<p align="center">
  <img src="doc/Imágenes/Plata.png" width="100px" alt="Trofeo plata">
  <img src="doc/Imágenes/Oro.png" width="140px" alt="Trofeo oro">
  <img src="doc/Imágenes/Bronce.png" width="100px" alt="Trofeo bronce">
</p>

Al terminar, sea cual sea el resultado, aparecerá una pantalla como la siguiente:

<p align="center">
  <img src="doc/Manual/Imágenes/Resultado.png" width="200px" alt="Resultado de partida">
</p>

De esta forma puedes elegir volver a jugar, compartir tus resultados o consultar la clasificación.

**La clasificación será un histórico de resultados en tus partidas**, ordenadas de forma descendente según la cantidad de puntos obtenidos.

<p align="center">
  <img src="doc/Manual/Imágenes/Clasificación.png" width="200px" alt="Clasificación">
</p>

Puedes filtrar los resultados buscando una categoría, e incluso borrar aquellos resultados que desees, tal y como hacíamos con las preguntas (desplazando la fila hacia la izquierda).

### Diseño responsive

La aplicación se adapta a cualquier tipo de dispositivo, ya sea un móvil (iPhone), una tablet (iPad)...

<p align="center">
  <img src="doc/Manual/Imágenes/iPad.png" width="266px" alt="iPad">
  <img src="doc/Manual/Imágenes/iPhone 5.png" width="200px" alt="iPhone 5">
  <img src="doc/Manual/Imágenes/Añadir.png" width="200px" alt="iPhone 8">
</p>


## Cómo probar la aplicación
Para probar la aplicación será tan fácil como clonar el proyecto o descargar la carpeta. Necesitaremos también un ordenador MacOS que contenga al menos Xcode 9.3 (disponible desde el 29 de marzo de 2018).

La carpeta contiene un proyecto de Xcode de tal forma que será tan sencillo como abrir el proyecto con este entorno de desarrollo y ejecutarlo en cualquier dispositivo, ya sea un simulador o conectado al ordenador (iPhone, iPad...).
