
# Sesion 2: Twitter: Creando la red (Introducción a igraph)
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

library(tidyverse) # tidyverse nos ayuda con la minupulación de datos
library(tidylog) # para saber qué está pasando con tidyverse
library(viridis) # viridis nos da colores bonitos
library(igraph) # Con igraph creamos y evaluamos nuetra red

## Vamos a crear la red: ----

## Primero nos quedamos únicamente con los tuits que tuvieron RTs
## El resto no nos da información

duque_rts <- duque_tw[!is.na(duque_tw$retweet_screen_name),]

## Creamos una matriz únicamente con los hubs y las autoridades

t_duque <- duque_rts[c(4,22)]
t_duque <- as.matrix(t_duque) # la matriz 
View(t_duque)

## Ahora creamos nuestra red

duque_net <- graph.empty() # Un red vacía
duque_net <- add.vertices(duque_net, length(unique(c(t_duque))), # Nuestros nodos serán todos nuestros usuarios 
                        name=as.character(unique(c(t_duque)))) # Y tendrán como nombre... su nombre de usuario

duque_net <- add.edges(duque_net, t(t_duque)) # Trasponemos la matriz para crear las conexiones

summary(duque_net) # Una red con 82817 nodos y 252482 conexiones (edges)

## Ahora populamos la red ---- 

## Primero las conexiones 

# Utilizamos la forma E(net) para agregar información a las conexiones
E(duque_net)$text <- duque_rts$text # El texto del tuit
E(duque_net)$text_width <- duque_rts$display_text_width # El largo del texto
E(duque_net)$urls <- duque_rts$urls_url # Si hay algun link

E(duque_net)$friends_hub <- duque_rts$friends_count # Siguiendo del hub
E(duque_net)$followers_hub <- duque_rts$followers_count # Seguidores del hub
E(duque_net)$time_hub <- duque_rts$created_at # hora en que hub dio RT
E(duque_net)$verified_hub <- duque_rts$verified # Si el hub es verificado

E(duque_net)$friends_auto <- duque_rts$retweet_friends_count # Siguiendo de la auto
E(duque_net)$followers_auto <- duque_rts$retweet_followers_count # Seguidores de la auto
E(duque_net)$time_auto <- duque_rts$retweet_created_at # hora en que auto creo tuit
E(duque_net)$verified_auto <- duque_rts$retweet_verified # Si el auto es verificado

summary(duque_net) # Una red con más información

# Ahora la información de los nodos ----

# Utilizamos la forma V(net) para agregar información a los nodos.
# Si queremos ver el nombre de un nodo, por ejemplo:

V(duque_net)$name[60000]

# Como los nodos están en un orden distinto en nuestro objeto igraph que en nuestro
# df de tuits, hay que hacer un poco de magia:

nodos <- as.data.frame(V(duque_net)$name) # Me quedo solo con los nodos (y mantengo el orden)
colnames(nodos) <- "nodos" 

duque_auto <- duque_rts %>% # Ahora solo veo autoridades y la info que quiero
  distinct(retweet_screen_name,.keep_all=T) %>% 
  select(retweet_screen_name,retweet_followers_count,retweet_friends_count,retweet_verified)
colnames(duque_auto) <- c("nodos","followers","friends","verified")

duque_hub <- duque_rts %>% # y luego solos hubs y la info que quiero
  distinct(screen_name,.keep_all=T) %>% 
  select(screen_name,followers_count,friends_count,verified)
colnames(duque_hub) <- c("nodos","followers","friends","verified")

duque_nodos <- rbind.data.frame(duque_auto,duque_hub) # Los uno
duque_nodos <- duque_nodos[!duplicated(duque_nodos$nodos),] # y borro duplicados

length(nodos$nodos) == length(duque_nodos$nodos) # Mismo número!

## Ahora, para mantener el orden de los nodos, utilizo join y 
## ¡¡SIEMPRE PONGO A MI DF NODOS PRIMERO!!

nodos <- left_join(nodos,duque_nodos)

nodos$nodos[23123] == V(duque_net)$name[23123] # Mismo nombre!

## Recien ahora podemos agregar info a nuestro nodos: 

V(duque_net)$followers <- nodos$followers
V(duque_net)$friend <- nodos$friends
V(duque_net)$verified <- nodos$verified

# No hay mucho más que agregar. Pero sí podemos extraer información de la propia 
# red y pasársela a los nodos... 


