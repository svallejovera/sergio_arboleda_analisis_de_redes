
# Sesion 2: Twitter: Cómo limpiar y organizar tu data
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

library(rtweet) # rtweet nos permite acceder a la data de TW
library(tidyverse) # tidyverse nos ayuda con la minupulación de datos

## Creamos el acceso al API:

create_token( # ¡Recuerda no compartir con nadie!
  app = "EL NOMBRE DE TU APP", # El nombre que le diste al app
  consumer_key = "CREDENCIALES TUYAS", # Copia y pega de tu página de developer de TW 
  consumer_secret = "CREDENCIALES TUYAS",
  access_token = "CREDENCIALES TUYAS",
  access_secret = "CREDENCIALES TUYAS"
)

## Busquemos nuestro término de interés: ----

duque_tw <- search_tweets(q = 'duque', # Hagamos sobre Iván Duque 
                          n = 100, # Vamos a necesitar muchos tuits
                          include_rts = T, # Si quiere que incluya RTs (siempre sí... es mejor tener data de más que de menos)
                          retryonratelimit = TRUE) # Sin esto, no funciona (demasiados tuits).

## Veamos la información que tenemos: ----

colnames(duque_tw) 

# Nos interesa la información de quién produjo el tuit original (autoridad) y
# de quien reprodujo el tuit (hub)

## Nos quedamos con la información relevante: ----

duque_tw <- duque_tw[,c(1:7,78:84,48:62,13:17,19)] # Cambio un poco el orden pero no es necesario
colnames(duque_tw) 

## Nos aseguramos no tener tuits duplicado (ojo que no me refiero a los RTs): ----

duque_tw <- duque_tw[!duplicated(duque_tw$status_id),]

## ¡Y listo!... la data queda a punto para explorarla.

## (No se olviden de grabar) ----
# setwd("/Users/su carpeta")
# save(duque_tw, file = "duque_tw.Rdata") # O el nombre que le quieran poner
