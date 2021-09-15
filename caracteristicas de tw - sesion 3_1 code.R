
# Sesion 3: Características de la red
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

library(tidyverse) # tidyverse nos ayuda con la minupulación de datos
library(tidylog) # para saber qué está pasando con tidyverse
library(viridis) # viridis nos da colores bonitos
library(igraph) # Con igraph creamos y evaluamos nuetra red

## Cargamos nuestra red: ----
setwd("/Users/tu directorio")
load("duque_net.Rdata")

### Centralidad: ----

## In-degree (cuánta gente me da RT)

V(duque_net)$in_degree <- degree(duque_net, mode = "in")

duque_in <- cbind.data.frame(V(duque_net)$name,V(duque_net)$in_degree)
colnames(duque_in) <- c("Usuario","Grado de Entrada")
duque_in <- duque_in[order(duque_in$`Grado de Entrada`, decreasing=T), ] # Ordenamos
head(duque_in, 10) # Más influyentes 

## Out-degree (cuánta gente da RT)

V(duque_net)$out_degree <- degree(duque_net, mode = "out")

duque_out <- cbind.data.frame(V(duque_net)$name,V(duque_net)$out_degree)
colnames(duque_out) <- c("Usuario","Grado de Salida")
duque_out <- duque_out[order(duque_out$`Grado de Salida`, decreasing=T), ] # Ordenamos
head(duque_out, 10) # Más activos (los soldados)

## Scale free world:

ggplot(duque_in,aes(`Grado de Entrada`)) +
  geom_density() ## ??

ggplot(duque_in,aes(log(`Grado de Entrada`+1))) +
  geom_density() ## ?? no hay escala que valga...

ggplot(duque_out,aes(`Grado de Salida`)) +
  geom_density() 

## Comparemos:
duque_all <- left_join(duque_in,duque_out)

ggplot(duque_all,aes(`Grado de Entrada`,`Grado de Salida`)) + 
  geom_point(alpha = .3) + 
  theme_minimal() 

## Cercanía: ----

V(duque_net)$close <- closeness(duque_net)

duque_close <- cbind.data.frame(V(duque_net)$name,V(duque_net)$close)
colnames(duque_close) <- c("Usuario","Cercanía")
duque_close <- duque_close[order(duque_close$Cercanía, decreasing=T), ] # Ordenamos
head(duque_close, 10) # Raro 

ggplot(duque_close,aes(Cercanía)) + 
  geom_density(alpha = .3) + 
  theme_minimal() ## ??

## Comparemos
duque_all <- left_join(duque_all,duque_close)

ggplot(duque_all,aes(`Grado de Entrada`,Cercanía)) + 
  geom_point(alpha = .3) + 
  theme_minimal() # ¿Qué puede estar pasando?

## Betweenness (intermediación): ----

V(duque_net)$between <- betweenness(duque_net)

duque_between <- cbind.data.frame(V(duque_net)$name,V(duque_net)$between)
colnames(duque_between) <- c("Usuario","Betweenness")
duque_between <- duque_between[order(duque_between$Betweenness, decreasing=T), ] # Ordenamos
head(duque_between, 10) # Por quienes más información pasa

## Comparemos
duque_all <- left_join(duque_all,duque_between)

ggplot(duque_all,aes(`Grado de Entrada`,log(Betweenness+1))) + 
  geom_point(alpha = .3) + 
  theme_minimal() # ¿Qué puede estar pasando?

## Distancias: ----

distancias_duque <- distance_table(duque_net) 
distancias_duque <- as.data.frame(unlist(distancias_duque)) # deshago la lista
distancias_duque$pasos <- c(1:20)

distancias_duque$`unlist(distancias_duque)`[20] # Desconectados

distancias_duque <- distancias_duque[-20,] # Quito esa info
colnames(distancias_duque)[1] <- "cantidad"

ggplot(distancias_duque,aes(x=pasos,y=cantidad)) + 
  geom_col() # Les resulta conocido? 

## Lo que queda claro es que algo más está pasando con nuestra red... 
## Veamos rápidamente que puede estar pasando:

save(duque_net, file = "duque_net_vars.Rdata")

## Visualizar la red (previa): ----

# layout_duque <- layout_with_fr(duque_net, grid = c("nogrid")) # No correr!

# V(duque_net)$l1<-layout_sub[,1]
# V(duque_net)$l2<-layout_sub[,2]

# save(duque_net, file = "duque_layout.Rdata")

load("duque_layout.Rdata")

## Graficar

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")

png(filename ="duque_net.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(V(duque_net)$l1*2.5,V(duque_net)$l2*2.5),cex=log(V(duque_net)$ind+1)/10, 
     # col=adjustcolor(new.color, alpha.f = .5), # xlim=c(140,-130),ylim=c(60,-50),
     xlab="", ylab="", axes=FALSE)
# legend("bottomright", c("CREO","UNES"), pch = c(19,17), col=c("royalblue3", "lightblue"))
dev.off()

# ¿Dónde están los verified?
V(duque_net)$col_veri <- ifelse(V(duque_net)$verified == T, "royalblue3", "gray96")
V(duque_net)$shape_veri <- ifelse(V(duque_net)$verified == T, 19, 17)

png(filename ="duque_net_ver.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(V(duque_net)$l1*2.5,V(duque_net)$l2*2.5),cex=log(V(duque_net)$ind+1)/10, 
     col=adjustcolor(V(duque_net)$col_veri, alpha.f = 1), # xlim=c(140,-130),ylim=c(60,-50),
     xlab="", ylab="", axes=FALSE, pch = V(duque_net)$shape_veri)
legend("bottomright", c("Verificado","Plebe"), pch = c(19,17), col=c("royalblue3", "gray96"))
dev.off()

# Pongamos el color por indegree

cols=setNames(colorRampPalette(c("grey96", "royalblue3"))(length(unique(V(duque_net)$in_degree))), sort(unique(V(duque_net)$in_degree))) 
V(duque_net)$col_degree <- cols[as.character(V(duque_net)$in_degree)]

png(filename ="duque_net_degree.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(V(duque_net)$l1*2.5,V(duque_net)$l2*2.5),cex=log(V(duque_net)$ind+1)/10, 
     col=adjustcolor(V(duque_net)$col_degree, alpha.f = 1), # xlim=c(140,-130),ylim=c(60,-50),
     xlab="", ylab="", axes=FALSE, pch = 19)
dev.off()

# Pongamos el color por betweeness

cols=setNames(colorRampPalette(c("grey96", "tomato3"))(length(unique(V(duque_net)$between))), sort(unique(V(duque_net)$between))) 
V(duque_net)$col_between <- cols[as.character(V(duque_net)$between)]

png(filename ="duque_net_between.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(V(duque_net)$l1*2.5,V(duque_net)$l2*2.5),cex=log(V(duque_net)$ind+1)/10, 
     col=adjustcolor(V(duque_net)$col_between, alpha.f = 1), # xlim=c(140,-130),ylim=c(60,-50),
     xlab="", ylab="", axes=FALSE, pch = 19)
dev.off()



