# Curso de Análisis de Redes Sociales (en RStudio)

Este curso está diseñado para profesionales y estudiantes de las ciencias sociales interesadxs en el uso de métodos cuantitativos y computacionales para el análisis de redes (sociales). El objetivo es lograr una aproximación sistemática a los fundamentos teóricos y empíricos del análisis de redes para quienes quieren participar de la relación cada vez más importante entre la ciencia de datos y las ciencias sociales. 

El seminario está estructurado en 5 sesiones de 3 horas. Cada sesión incluirá una parte tanto teórica como práctica, complementada con ejercicios para reforzar el material en casa. La plataforma principal que utilizaremos en este curso será R/R-Studio. 

- Fecha: 13 de septiembre a 17 de septiembre, 2021

- Horario: 6:00PM - 9:00PM

## Introducción

El análisis de redes sociales es una actividad que mucho depende de las computadores (y del poder computacional). Por lo tanto, este curso introductorio es un acercamiento al análisis de redes sociales usando **igraph**, un paquete de R especializada en el análisis de redes, y el **API** (*Application Programming Interface*) de Twitter, que utilizaremos para bajar información para construir nuestras redes. Para aprovechar de mejor manera este curso se recomienda que lxs participantes tengan una conocimiento básico de R (¡pero todxs son bienvenidxs!). 

Al finalizar el curso, lxs participantes tendrán una idea clara del *pipeline* necesario para configurar una investigación basada en el análisis de redes sociales. Por lo tanto, aprenderemos como: 1) obtener data y crear un red, 2) visualizar y describir esta red, y 3) analizar la topografía y los cambio dentro de esta red. 

El análisis de las redes sociales abre la posibilidad de analizar data que es abundante, detallada y fácilmente disponible. A la gente (y a los políticos) les encanta tuitear, retuittear, seguir y ser seguido. Y, a nosotros, nos encanta la data. A pesar de depender fuertemente de un computador, el análisis de las redes sociales es intuitivo y, seamos honestos, a todo el mundo le gusta una imagen con colores bonitos.<sup id="a1">[1](#f1)</sup> 

Todo el material está, y estará por mucho tiempo, disponible en GitHub. 

> :warning: Es importante completar la [Sesión 0](#sesión-0) **antes** de iniciar el curso. 

## Contenidos del curso

### Sesión 0

La idea es comenzar este curso, como dicen los gringos, *hitting the ground running*. Si estás aquí, seguramente ya tienes ciertos (elementales, básicos, avanzandos, programas en C++) conocimientos de R/R-Studio. Si no los tienes, puedes ver [este tutorial de cómo instalar R y RStudio](https://www.youtube.com/watch?v=TFGYlKvQEQ4) y [este tutorial sobre las funcionaes básicas de R y RStudio](https://www.youtube.com/watch?v=BvKETZ6kr9Q). Para el inicio del curso, es importante que tengas ciertos elementos listos, los cuales detallo a continuación. 

#### Paquetes de R

Primero, debes instalar los siguiente paquetes en R:

- igraph
- tidyverse
- tidytext
- httr
- rjson
- rtweet
- viridis

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


Si esto no funciona, busca ayuda en Google. En mi experiencia, si yo tengo un problema o duda de cómo hacer algo en R, ya hay otras mil personas que también lo tuvieron y otras cien que saben la respuesta (y la han publicado). Buscar ayuda en Google es fácil: 1) copia y pega el mensaje de error que te aperece en R, 2) da click en el primera o segundo enlace, 3) ¡listo! ahí está tu solución. La página principal para solucionar tus dudas y problemas (de R) es [stackoverflow](https://stackoverflow.com/]).

Finalmente, si estás utilizando **Windows** se recomienda que instales [RTools suite](https://cran.r-project.org/bin/windows/Rtools/), y si estás en **OS X** se recomienda que instales [XCode](https://apps.apple.com/gb/app/xcode/id497799835?mt=12) desde el App Store.

#### Twitter API

Vamos a analizar redes sociales por lo tanto necesitamos data de una red social. Qué mejor que Twitter (hay mejores pero también hay peores... en fin, todas sacan lo peor del ser humano). Algunas de las muchas ventajas de la data de Twitter es su abundancia, su detalle y la facilidad de acceder a esta, a diferencia de cualquier otra red social (e.g., Facebook), que tiene toda su información bien guardada (y tu información disponible al mejor postor). 

Para poder acceder a la información de Twitter, es necesario primero solicitar acceso a su API (*Application Programming Interface*). El API no es más que una dirección en línea de alguien que quiere compartir información de manera rápida y sencilla. Hay ciertos APIs que no requieren autentificación. Sin embargo, hay otros APIs, como el de Twitter, que requieren una autentifiación (*token* y *usuario*). La explicación de cómo registrarse al API de Twitter la puede encontrar [aquí](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/tw_api.md). 

#### Data para el curso

La data que vamos a estar utilizando en este curso la puede encontrar [aquí](https://uofh-my.sharepoint.com/:f:/g/personal/svallej2_cougarnet_uh_edu/Ep7WBEAoteZGlOuejzL_rREBr660cUKG0GuBDh5qO363gg?e=lqBRCU). 

### Sesión 1

1. Introducción al curso ([Diapositivas 0](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/introduccion.pdf))
2. Introducción a las redes sociales ([Diapositivas I](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/Intro%20a%20las%20redes%20sociales%20-%20sesion%201.pdf))
    1. ¿Cómo se forman las redes?
    2. ¿Qué nos dicen las redes?
    3. Terminología de redes
    4. ¿Qué nos interesa medir en las redes?
    5. Las redes sociales (Twitter): ¿qué nos pueden decir (y qué no)?

2. El Pipeline ([Diapositivas II](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/pipeline%20-%20sesion%201_2.pdf))

3. Lecturas recomendadas
    - Barabási (2014) - Network Science, Ch. 1 ([link](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/lectura%20sesion%201.pdf))
    - Calvo y Aruguete (2020) - Fake news, trolls y otros encantos: cómo funcionan (para bien y para mal) las redes, Intro ([link](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/lectura%20sesion%201b.pdf))
    
### Sesión 2

1. Obteniendo la data y creando la red 
    1. ¿Qué tipo de data utilizamos?
    2. ¿Dónde y cómo la conseguimos? ([Diapositivas I](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_1.pdf), [Código I](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_1%20code.R))
        - Bajar la data de TW
    3. Estructura de la data ([Diapositivas II](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_2.pdf), [Código II](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_2%20code.R))
    4. Descripción de la data ([Diapositivas III](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_3.pdf), [Código III](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_3%20code.R))
    5. Agregando información a la red ([Diapositivas IV](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_4.pdf), [Código IV](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_44%20code.R), [Diapositivas V](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_4.pdf), [Código V](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/data%20de%20tw%20-%20sesion%202_4%20code.R))

2. Ejercicios y lecturas recomendadas
    - Ejercicios, [link](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/ejercicios%20sesion%202.pdf)
    - Ognyanova (2016) - Network Analysis and Visualization with R and igraph, [link](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/NetSciX_2016_Workshop.pdf)

### Sesión 3 

1. Visualizando y describiendo la red 
    1. Características de la red ([Diapositivas](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/caracteristicas%20de%20tw%20-%20sesion%203_1.pdf), [Código](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/caracteristicas%20de%20tw%20-%20sesion%203_1%20code.R))
        - In-degree y out-degree
        - Centralización
    2. Detección de comunidades ([Diapositivas](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/comunidades%20de%20tw%20-%20sesion%203_2.pdf), [Código](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/comunidades%20de%20tw%20-%20sesion%203_2%20y%20sesion%203_3%20code.R))
        - ¿Qué es y para qué sirve?
        - ¿Cómo la aplicamos a nuestra data de Twitter?
            - Leading eigenvectors y random-walk
        - ¿Qué nos dicen las comunidades sobre nuestras redes?
    3. Visualizando la red ([Diapositivas](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/comunidades%20de%20tw%20-%20sesion%203_3.pdf), [Código](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/comunidades%20de%20tw%20-%20sesion%203_2%20y%20sesion%203_3%20code.R), 

2. Ejercicios y lecturas recomendadas
    - Ejercicios, [link](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/ejercicios%20sesion%203.pdf).
    - Calvo y Aruguete (2020) - Fake news, trolls y otros encantos: cómo funcionan (para bien y para mal) las redes, Cap 6 ([link](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/Fake%20news%2C%20trolls%20y%20otros%20encantos%20by%20Ernesto%20Calvo%2C%20Natalia%20Aruguete%20Cap%206.pdf))


### Sesión 4

1. Analizando las comunidades ([Diapositivas](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/analsis%20de%20tw%20-%20sesion%204_1%20y%20sesion%204_2.pdf), [Código I](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/analisis%20de%20tw%20-%20sesion%204_1%20code.R), [Código II](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/analisis%20de%20tw%20-%20sesion%204_2%20code.R))
    1. E/I, homofilia, modularidad
    2. Dimensiones de la red
    3. Activación de la red
    5. Explorando la topografía 

2. Ejercicios y lecturas recomendadas
    - Calvo y Aruguete (2020) - Fake news, trolls y otros encantos: cómo funcionan (para bien y para mal) las redes, Cap7 ([link](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/Fake%20news%2C%20trolls%20y%20otros%20encantos%20by%20Ernesto%20Calvo%2C%20Natalia%20Aruguete%20Cap%207.pdf))

### Sesión 5

1. Características de las redes sociales ([Diapositivas](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/analsis%20de%20tw%20-%20sesion%205_1.pdf), [Código](https://github.com/svallejovera/sergio_arboleda_analisis_de_redes/blob/main/analisis%20de%20tw%20-%20sesion%205_1%20code.R))
    1. ¿La era de efectos mínimos?
    2. Disonancia y resonancia cognitiva en redes
    3. Experimentos 
    4. Análisis de texto
    5. *Rising stars and rising tides*
    6. La forma de la viralidad

2. Ejercicios y lecturas recomendadas
    - Banks, Antoine, et al. "# polarizedfeeds: Three experiments on polarization, framing, and social media." The International Journal of Press/Politics 26.3 (2021): 609-634. [link](https://gvpt.umd.edu/sites/gvpt.umd.edu/files/pubs/%23PolarizedFeeds.pdf)
    - Aruguete, Natalia, and Ernesto Calvo. "Time to# protest: Selective exposure, cascading activation, and framing in social media." Journal of communication 68.3 (2018): 480-502. [link](https://academic.oup.com/joc/article/68/3/480/4972616?casa_token=n8FF_NPbaokAAAAA:9A57qyk1S6yg6cJZo3BrX4YTAiMLKVhGDf_HyPv_os4UD1-RaxsjrO3bjpaIfhkKwtRUZpDlJVSbPQ)
    - Lin, Yu-Ru, et al. "Rising tides or rising stars?: Dynamics of shared attention on Twitter during media events." PloS one 9.5 (2014): e94093. [link](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0094093)
    - Vallejo Vera, Sebastian. "Rage Within the Machine: Activation of Racist Content in Social Media." Working Paper 8 iLCSS (2021). [link](https://ilcss.umd.edu/static/6d7c40d89a13fef276f407e9ed1a2520/rage.pdf)


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
