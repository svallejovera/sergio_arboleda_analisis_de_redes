
# Sesion 4: Análisis de la red II
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

rm(list = ls(all=TRUE)) # Esta función limpia mi environment

library(tidyverse) # tidyverse nos ayuda con la minupulación de datos
library(tidylog) # para saber qué está pasando con tidyverse
library(RColorBrewer) # RColorBrewer nos da colores bonitos
library(igraph) # Con igraph creamos y evaluamos nuetra red
library(tidytext) # Como tidyverse pero para texto

## Cargamos nuestra red: ----

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Data")
load("duque_sub_com.Rdata")

## La topografía: ----

## Hay usuarios con alto degree y bajo degree: 

V(duque_sub)$alto_grado <- if_else(V(duque_sub)$in_degree >5,1,0)
V(duque_sub)$bajo_grado <- if_else(V(duque_sub)$in_degree >5,0,1)

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")

png(filename ="duque_net_com_alto.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300) # Baja resolución (sin edges)
plot(cbind(-V(duque_sub)$l2,-V(duque_sub)$l1), # Mis coordenadas del layout
     cex=V(duque_sub)$alto_grado/10, # El tamaño de los nodos basado ser alto o bajo grado
     col=adjustcolor(V(duque_sub)$col_comun, alpha.f = .8), # El color de los nodos basado en su comunidad
     pch = V(duque_sub)$shape_comun, # La forma de mis nodos basada en su comunidad
     xlab="", ylab="", axes=T) # Si quiero poner algún nombre a los ejes aquí lo puedo hacer
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off()

png(filename ="duque_net_com_bajo.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300) # Baja resolución (sin edges)
plot(cbind(-V(duque_sub)$l2,-V(duque_sub)$l1), # Mis coordenadas del layout
     cex=V(duque_sub)$bajo_grado/10, # El tamaño de los nodos basado ser alto o bajo grado
     col=adjustcolor(V(duque_sub)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
     pch = V(duque_sub)$shape_comun, # La forma de mis nodos basada en su comunidad
     xlab="", ylab="", axes=T) # Si quiero poner algún nombre a los ejes aquí lo puedo hacer
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off()

## Tiempo para dar RT

E(duque_sub)$tiempo_RT <- E(duque_sub)$time_hub - E(duque_sub)$time_auto
duque_sub_df <- as_long_data_frame(duque_sub) # Primero lo convierto en df para poder estimar el EI

nodos <- as.data.frame(V(duque_sub)$name) # Me quedo solo con los nodos (y mantengo el orden)
colnames(nodos) <- "nodos" 

duque_tiempo <- duque_sub_df %>% # y luego solos hubs y la info que quiero
  group_by(from_name) %>%
  mutate(tiempo_RT_prom = mean(log(tiempo_RT))) %>%
  distinct(from_name,.keep_all=T) %>% 
  select(from_name,tiempo_RT_prom)
colnames(duque_tiempo) <- c("nodos","tiempo_RT_prom")

## Ahora, para mantener el orden de los nodos, utilizo join y 
## ¡¡SIEMPRE PONGO A MI DF NODOS PRIMERO!!

nodos <- left_join(nodos,duque_tiempo)

nodos$nodos[10000] == V(duque_sub)$name[10000] # Mismo nombre!

V(duque_sub)$tiempo_RT_prom <- nodos$tiempo_RT_prom

png(filename ="duque_net_com_tiempo_RT.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300) # Baja resolución (sin edges)
plot(cbind(-V(duque_sub)$l2,-V(duque_sub)$l1), # Mis coordenadas del layout
     cex=ifelse(is.na(V(duque_sub)$tiempo_RT_prom),0,(10/(V(duque_sub)$tiempo_RT_prom^2))), # El tamaño de los nodos basado en tiempo RT prom
     col=adjustcolor(V(duque_sub)$col_comun, alpha.f = .1), # El color de los nodos basado en su comunidad
     pch = V(duque_sub)$shape_comun, # La forma de mis nodos basada en su comunidad
     xlab="", ylab="", axes=T) # Si quiero poner algún nombre a los ejes aquí lo puedo hacer
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off()


## Ahora... mientras más rápido le doy RT, mayor congruencia cognitiva y mayor amplificación... 
## Lo que nos deja listo para el siguiente y último módulo.


