
# Sesion 2: Twitter: Explorando la data
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

library(tidyverse) # tidyverse nos ayuda con la minupulación de datos
library(viridis) # viridis nos da colores bonitos

## Carga la data que bajaste:

setwd("/Users/su carpeta")
load("duque_tw.Rdata") 

## Describiendo la data: -----

## RT vs tuits originales

table(is.na(duque_tw$retweet_name)) # Muchos RTs... esto es lo que esperamos. 

## Veamos cuáles son las 10 cuentas más retuiteadas: 

top_rt_auto <- duque_tw %>%
  filter(!is.na(retweet_screen_name)) %>% # Eliminamos los que no fueron RTs
  group_by(retweet_screen_name) %>% # Agrupamos por el nombre de la autoridad
  mutate(frec_rt_name = n()) %>% # Calculamos la frecuencia
  distinct(retweet_screen_name,retweet_name,frec_rt_name) # Mantenemos solo la info necesaria

top_rt_auto <- top_rt_auto[order(top_rt_auto$frec_rt_name, decreasing=T), ] # Ordenamos
names(top_rt_auto) <- c("Usario","Nombre","Tweets") # Damos nombres
head(top_rt_auto, 10) # Vemos los más RT (y cuántas veces)

## Veamos cuáles son las 10 cuentas que más retuitearon: 

top_rt_hub <- duque_tw %>%
  group_by(screen_name) %>% # Agrupamos por el nombre del hub
  mutate(frec_rt_name = n()) %>% # Calculamos la frecuencia
  distinct(screen_name,frec_rt_name) # Mantenemos solo la info necesaria

top_rt_hub <- top_rt_hub[order(top_rt_hub$frec_rt_name, decreasing=T), ] # Ordenamos
names(top_rt_hub) <- c("Usuario","Tweets") # Damos nombres
head(top_rt_hub, 10) # Vemos los más RT (y cuántas veces)

## Veamos cuántas autoridad/hubs son verificadas:

table(duque_tw$retweet_verified[!is.na(duque_tw$retweet_screen_name)]) # autoridades

table(duque_tw$verified[!is.na(duque_tw$retweet_screen_name)]) # hubs q dieron RT
table(duque_tw$verified) # hubs q crearon tuit original

## ¿Cómo se diferencian los que generan tuits de quienes los reproducen:

f_f_auto <- duque_tw %>%
  filter(!is.na(retweet_screen_name)) %>% # Eliminamos los que no fueron RTs
  distinct(retweet_screen_name,.keep_all=T) %>% 
  select(retweet_followers_count,retweet_friends_count)
colnames(f_f_auto) <- c("followers_count","friends_count") # Arreglo para poder bind
f_f_auto$Tipo <- "Autoridad" # Nombre para diferenciar de los hubs

f_f_hub <- duque_tw %>%
  distinct(screen_name,.keep_all=T) %>% 
  select(followers_count,friends_count)
f_f_hub$Tipo <- "Hub"

f_f_all <- rbind.data.frame(f_f_auto,f_f_hub) # Juntamos para que ggplot entienda

ggplot(f_f_all, aes(log(followers_count+1),fill= Tipo,color=Tipo)) +
  geom_density(alpha=.5) + # Curva de densidad
  labs(x="Seguidores (log)", # Nombres
       title = "Distribución de seguidores por tipo de usuario") +
  theme_minimal() + # Bonito
  scale_color_viridis(discrete = T) + # Más bonito
  scale_fill_viridis(discrete = T) +
  theme(legend.position = "bottom")
  
ggplot(f_f_all, aes(log(friends_count+1),fill= Tipo,color=Tipo)) +
  geom_density(alpha=.5) +
  labs(x="Siguiendo (log)",
       title = "Distribución de a cuántos siguen por tipo de usuario") +
  theme_minimal() +
  scale_color_viridis(discrete = T) +
  scale_fill_viridis(discrete = T) +
  theme(legend.position = "bottom")

## Claramente, son dos tipos diferentes... 

## Pero esto solo es contar ocurrencias, todavía no es la red. 
## ¡Armemos la red!
