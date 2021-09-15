
# Sesion 2: Twitter: Cómo obtener su data
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

# install.packages("rtweet") # solamente una vez

library(rtweet) # rtweet nos permite acceder a la data de TW
library(tidyverse) # tidyverse nos ayuda con la minupulación de datos

## Tus credenciales> ----
# Para acceder al API, TW requiere que te registres y con eso obtener tus credenciales. 
# TW tiene un excelente tutorial que te explica como hacerlo (también puedes encontrar 
# uno en español en el GitHub del curso). 

vignette("auth", package = "rtweet") # Te lleva al tutorial 

# Una vez que tienes tus credenciales, creamos el acceso:

create_token( # ¡Recuerda no compartir con nadie!
  app = "EL NOMBRE DE TU APP", # El nombre que le diste al app
  consumer_key = "CREDENCIALES TUYAS", # Copia y pega de tu página de developer de TW 
  consumer_secret = "CREDENCIALES TUYAS",
  access_token = "CREDENCIALES TUYAS",
  access_secret = "CREDENCIALES TUYAS"
)

# Esto lo tienes que hacer solo una vez por sesión. El acceso ya está en tu environment

## Ahora ya podemos buscar el término que nos interesa: ----

duque_tw <- search_tweets(q = 'duque', # El término que quiere buscar
                          n = 100, # Cuántos tuits quiere que me devuelve el API
                          include_rts = T, # Si quiere que incluya RTs (siempre sí... es mejor tener data de más que de menos)
                          retryonratelimit = TRUE) # Si quiero que automáticamente vuelva a intenter si llego al límite de tuits por 15 min.

duque_tw %>% as_tibble() # Me permite visualizar mejor la base de datos 
duque_tw$text[1] # El texto de un tuit

## Podemos también buscar el timeline de un usuario: ----

timelines_pols <- get_timelines(c("IvanDuque", "petrogustavo", "ClaudiaLopez"), n=100)
timelines_pols %>% as_tibble()

timelines_pols$text[1] # tuit de Duque
timelines_pols$text[101] # tuit de Petro
timelines_pols$text[201] # tuit de López

## ¿Quieren información acerca de algún usuario? También se puede: ----

usuarios_col <- lookup_users(c("IvanDuque", "petrogustavo", "ClaudiaLopez"))
usuarios_col$description

## Si quieren saber a qué le han dado like algún usuario: ----

like_col <- get_favorites(c("IvanDuque", "petrogustavo", "ClaudiaLopez"))
like_col %>%as_tibble() 

table(like_col$screen_name[like_col$favorited_by=="IvanDuque"]) # Estas son las cuentas a las que Duque le ha dado like

## Y los followers de algún usuario: -----

follow_duque <- get_followers("IvanDuque") # solo los primeros 5000 
follow_duque %>% as_tibble() # Solo te da el ID.

follow_duque_usuario <- lookup_users("1388135429174611974") 
follow_duque_usuario$description

## API para el stream ----

colombia_stream <- stream_tweets("colombia", # El término que quiero buscar. Si utilizo "" me devuelve un sample de TODA la data de TW
                          timeout = 100) # Por cuánto tiempo quiero que corra.

colombia_stream %>% as_tibble()
colombia_stream$text[2]


