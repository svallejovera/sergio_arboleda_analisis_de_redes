# Curso de Análisis de Redes Sociales (en RStudio)

Este curso está diseñado para profesionales y estudiantes de las ciencias sociales, interesados en el uso de métodos cuantitativos y computacionales para el análisis de redes (sociales). El objetivo es dar una aproximación sistemática a los fundamentos teóricos y empíricos del análisis de redes para quienes quieren participar de la, cada vez más importante, relación entre la ciencia de datos y las ciencias sociales. 

El seminario está estructurado en 5 sesiones de 3 horas. Cada sesión incluirá tanto una parte teórica como práctica, complementada con ejercicios para reforzar en casa. La plataforma principal que utilizaremos en este curso será R/R-Studio. 

- Fecha: 13 de septiembre a 17 de septiembre, 2021

- Horario: 8:00AM - 11:00AM

## Introducción

El análisis de redes sociales es una actividad que depende fuertemente de las computadores (y del poder computacional). Por lo tanto, esta introducción es un acercamiento al análisis de redes sociales utilizando **igraph**, un paquete de R especializada en el análisis de redes, y el **API** (*application programming interface*) de Twitter, que utilizaremos para bajar información para construir nuestras redes. Para aprovechar de mejor manera este curso se recomienda que lxs participantes tengan una conocimiento básico de R (¡pero todxs son bienvenidxs!). 

Al finalizar el curso, lxs participantes tendrán una idea clara del *pipeline* necesario para configurar una investigación basada analizar redes sociales. Por lo tanto, aprenderemos como 1) obtener data y crear un red, 2) visualizar y describir esta red, y 3) analizar la topografía y los cambio dentro de esta red. 

El análisis de las redes sociales abre la posibilidad de analizar data que es abundante, detallada, y fácilmente disponible. A la gente (y a los políticos) le encanta tuitear, retuittear, seguir, y ser seguido. Y a nosotros nos encanta la data. A pesar de depender fuertemente de un computador, el análisis de las redes sociales es intuitivo y, seamos honestos, a todo el mundo le gusta una imagen con color bonitos.<sup id="a1">[1](#f1)</sup> 

Todo el material está, y estará por mucho tiempo, disponible en GitHub. 

  - [Instructions to install the required software](#instructions-to-install-the-required-software)
    - [quanteda (for R)](#quanteda-for-r)
    - [spaCyR (for R)](#spacyr-for-r)
    - [Extra packages](#extra-packages)
  - [Some final words](#some-final-words)
  
## Sesión 0

La idea es comenzar este curso, como dicen los gringos, *hitting the ground running*. Si estás aquí, seguramente ya tienes ciertos (basiquísimos, básicos, avanzandos, programas en C++) conocimientos de R/R-Studio. Si no los tienes, puedes ver [este tutorial de cómo instalar R y RStudio](https://www.youtube.com/watch?v=TFGYlKvQEQ4) y [este tutorial sobre las funcionaes básicas de R y RStudio](https://www.youtube.com/watch?v=BvKETZ6kr9Q). Para el inicio del curso, es importante que tengas ciertos elementos listos, los cuales detallo a continuación. 

### Paquete de R

Primero, debes instalar los siguiente paquetes en R:

- igraph
- tidyverse
- httr
- rjson
- rtweet

Puedes instalarlos desde RStudio, dando click a Tools > Install Package, o ejecutando estos comandos: 

```
install.packages("igraph") # Análisis de redes
install.packages("tidyverse") # Conjunto de paquetes para manipulación de datos y visualizaciones
install.packages("tidytext") # Conjunto de paquetes para manipulación y análsis de texto
install.packages("httr") # Scrapping
install.packages("rjson") # Scrapping
install.packages("rtweet") # Twitter
install.packages("viridis") # Colores bonitos

```

Recuerda que sólo debes instalar los paquetes una vez (y no cada vez que reinicias RStudio). Ahora bien, puede que tengas problemas instalando ciertos paquetes. De vez en cuando, todos los tenemos. Una de las grandes ventajas de utilizar R es la abundancia de recursos en línea que existen para solucionar estos problemas. 

Para comenzar, si tienes problemas instalando paquetes, asegúrate conectado al internet y que https://cloud.r-project.org/ no esté bloqueado por tu firewall o proxy. 


Si esto no funciona, busca ayuda en Google. En mi experiencia, si yo tengo un problema o duda de cómo hacer algo en R, ya hay otras mil personas que también lo tuvieron, y otras cien que saben la respuesta (y la han publicado). Buscar ayuda en Google es fácil: 1) copia y pega el mensaje de error que te aperece en R, 2) da click en el primera o segundo enlace, 3) ¡listo! ahí está tu solución. La página principal para solucionar tus dudas y problemas (de R) es [stackoverflow](https://stackoverflow.com/]).

Finalmente, si estás utilizando **Windows** se recomienda que instales [RTools suite](https://cran.r-project.org/bin/windows/Rtools/), y si estás en **OS X** se recomienda que instales [XCode](https://apps.apple.com/gb/app/xcode/id497799835?mt=12) desde el App Store.

### Twitter API

Vamos a analizar redes sociales por lo tanto necesitamos data de una red social. Qué mejor que Twitter (hay mejores pero también hay peores... en fin, todas sacan lo peor del ser humano). Algunas de las muchas ventajas de la data de Twitter es su abundancia, su detalle y la facilidad de acceder a esta, a diferencia de cualquier otra red social (e.g., Facebook), que tiene toda su información bien guardada (y tu información disponible al mejor postor). 

Para poder acceder a la información de Twitter, es necesario primero solicitar acceso a su API (*application programming interface*). El API no es más que una dirección en línea de alguien que quiere compartir información de manera rápida y sencilla. Hay ciertos APIs que no requieren autentificación. Sin embargo, hay otros APIs, como el de Twitter, que requieren una autentifiación (*token* y *usuario*). La explicación de cómo registrarse al API de Twitter la puede encontrar [aquí](https://github.com/TiagoVentura/ventura_calvo_flacso_workshop/blob/main/install_fest.md). 

## Contenidos del curso

### Sesión 1: Introducción a las redes sociales (Diapositivas)

a.	¿Cómo se forman las redes?
b.	¿Qué nos dicen las redes?
c.	Terminología de redes
d.	¿Qué nos interesa medir en las redes?
e.	Las redes sociales (Twitter): ¿qué nos pueden decir (y que no)?

### Sesión 2: Obteniendo la data y creando la red (Diapositivas, Código)

a.	¿Qué tipo de data utilizamos?
b.	¿Dónde y cómo la conseguimos?
  a.	Bajar la data de TW
c.	Estructura de la data
d.	Agregando información a la red

### Sesión 3: Visualizando y describiendo la red (Diapositivas, Código)

a.	Baja información
b.	Alta información con
c.	Características de la red 
  a.	In-degree y out-degree
  b.	Centralización
  c.	E/I, homofilia, modularidad
d.	Detección de comunidades 
  a.	¿Qué es y para qué sirve?
  b.	¿Cómo la aplicamos a nuestra data de Twitter?
    i.	Leading eigenvectors y random-walk
  c.	¿Qué nos dicen las comunidades sobre nuestras redes?

### Sesión 4

1. Interpretando el cambio (Diapositivas, Código)
  a.	Redes estáticas y dinámicas
  b.	Amigos, seguidores y retweets (conexiones direccionadas)
  c.	Rising stars and rising tides
  d.	Explorando la topografía 
2. Ejercicios y lecturas recomendadas

### Sesión 5: Características de las redes sociales (Diapositivas, Código)

a.	¿La era de efectos mínimos?
b.	Disonancia y resonancia cognitiva en redes
c.	Experimentos 
d.	Análisis de texto
e.	La forma de la viralidad

## Materiales

Todos los materiales, tanto diapositivas como el código, está disponible en [este repositorio](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes). Si estas familiarizado con GitHub, puedes clonarlo localmente y tener toda la información en un solo lugar

&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;

<b id="f1">1</b> Aprenderemos cómo hacer imágenes con colores bonitos. [↩](#a1)
