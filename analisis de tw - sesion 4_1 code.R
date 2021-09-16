
# Sesion 4: Análisis de la red I
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

## Comenzamos viendo las características de las comunidades: ----

## Comunicación entre comunidades:
duque_sub_df <- as_long_data_frame(duque_sub) # Primero lo convierto en df 

E(duque_sub)$interno <- ifelse(duque_sub_df$from_comunidad == duque_sub_df$to_comunidad, 1, 0)
table(E(duque_sub)$interno)  # Uff... poca comunicación entre comunidades. 

## Veamos cómo se ve esto:
E(duque_sub)$color_int <- ifelse(E(duque_sub)$interno==1, "darkgreen", "gray96")

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")

png(filename ="duque_net_com_int.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot.igraph(duque_sub, # Uso otra función... plot.igraph!
            vertex.label= "", # Sin nombres
            layout=cbind(-V(duque_sub)$l2,-V(duque_sub)$l1), 
            vertex.size=log(V(duque_sub)$in_degree+1)/5, 
            vertex.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .1), 
            vertex.frame.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .1),
            edge.color = E(duque_sub)$color_int , edge.width=0.5, edge.arrow.size=0, # Color y tamaño de los edges
            edge.curved=TRUE) # Si quiero que los edges sean curvos
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off() 

E(duque_sub)$color_ext <- ifelse(E(duque_sub)$interno==1, "gray96","darkgreen")

png(filename ="duque_net_com_ext.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot.igraph(duque_sub, # Uso otra función... plot.igraph!
            vertex.label= "", # Sin nombres
            layout=cbind(-V(duque_sub)$l2,-V(duque_sub)$l1), 
            vertex.size=log(V(duque_sub)$in_degree+1)/5, 
            vertex.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .1), 
            vertex.frame.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .1),
            edge.color = E(duque_sub)$color_ext , edge.width=0.5, edge.arrow.size=0, # Color y tamaño de los edges
            edge.curved=TRUE) # Si quiero que los edges sean curvos
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off() 

## Activación de la red: ----
## ¿Qué activa a los usuarios?

## Menciones: 

# Vamos a extraer las menciones (@) más comunes de cada comunidad
duque_sub_df$from_comunidad <- ifelse(duque_sub_df$from_comunidad == 4,"Oposición","Gobierno")

menciones <- duque_sub_df %>%
  group_by(from_comunidad) %>%
  unnest_tokens(menciones, text, "tweets", to_lower = F) %>%
  filter(str_detect(menciones, "^@")) %>%
  add_count(menciones, name = "num_menciones", sort = T) %>%
  distinct(menciones,num_menciones,.keep_all = T) %>%
  top_n(15)

menciones_opo <- head(menciones$menciones[menciones$from_comunidad == "Oposición"], n=10)
menciones_gob <- head(menciones$menciones[menciones$from_comunidad == "Gobierno"], n=10)

## Graficamos
setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")

png(filename ="duque_activacion_menciones_opo.png", width = 15, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
par(mfrow = c(2,5))
for(i in 1:length(menciones_opo)){ # digo a R que repita esta operación por el largo de mi objecto
  # selecciones los edges que mencionan a ese usuario
  select_edges <-which(str_detect(E(duque_sub)$text,menciones_opo[i]))
  # esos edges los extraigo de mi red
  net_name <- subgraph.edges(duque_sub, eids = select_edges, delete.vertices = TRUE)
  # grafico
  plot(cbind(-V(net_name)$l2,-V(net_name)$l1), # Mis coordenadas del layout
       cex=log(V(net_name)$in_degree+1)/5, # El tamaño de los nodos basado en su in degree
       col=adjustcolor(V(net_name)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
       pch = V(net_name)$shape_comun, # La forma de mis nodos basada en su comunidad
       xlim=c(-60, 160),ylim=c(-100,60), # Para que todos ocupen el mismo espacio
       xlab="", ylab="", axes=T)
  title(paste0("Se menciona a ",menciones_opo[i]))
}
dev.off()

png(filename ="duque_activacion_menciones_gob.png", width = 15, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
par(mfrow = c(2,5))
for(i in 1:length(menciones_gob)){ # digo a R que repita esta operación por el largo de mi objecto
  # selecciones los edges que mencionan a ese usuario
  select_edges <-which(str_detect(E(duque_sub)$text,menciones_gob[i]))
  # esos edges los extraigo de mi red
  net_name <- subgraph.edges(duque_sub, eids = select_edges, delete.vertices = TRUE)
  # grafico
  plot(cbind(-V(net_name)$l2,-V(net_name)$l1), # Mis coordenadas del layout
       cex=log(V(net_name)$in_degree+1)/5, # El tamaño de los nodos basado en su in degree
       col=adjustcolor(V(net_name)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
       pch = V(net_name)$shape_comun, # La forma de mis nodos basada en su comunidad
       xlim=c(-60, 160),ylim=c(-100,60), # Para que todos ocupen el mismo espacio
       xlab="", ylab="", axes=T)
  title(paste0("Se menciona a ",menciones_gob[i]))
}
dev.off()

## Hashtags: 

# Vamos a extraer los hashtags (#) más comunes de cada comunidad

hashtags <- duque_sub_df %>%
  group_by(from_comunidad) %>%
  unnest_tokens(hashtags, text, "tweets", to_lower = F) %>%
  filter(str_detect(hashtags, "^#")) %>%
  add_count(hashtags, name = "num_hashtag", sort = T) %>%
  distinct(hashtags,num_hashtag,.keep_all = T) %>%
  top_n(15)

hashtags_opo <- head(hashtags$hashtags[hashtags$from_comunidad == "Oposición"], n=10)
hashtags_gob <- head(hashtags$hashtags[hashtags$from_comunidad == "Gobierno"], n=10)

## Graficamos

png(filename ="duque_activacion_hashtags_opo.png", width = 15, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
par(mfrow = c(2,5))
for(i in 1:length(hashtags_opo)){ # digo a R que repita esta operación por el largo de mi objecto
  # selecciones los edges que mencionan el hashtag
  select_edges <-which(str_detect(E(duque_sub)$text,hashtags_opo[i]))
  # esos edges los extraigo de mi red
  net_name <- subgraph.edges(duque_sub, eids = select_edges, delete.vertices = TRUE)
  # grafico
  plot(cbind(-V(net_name)$l2,-V(net_name)$l1), # Mis coordenadas del layout
       cex=log(V(net_name)$in_degree+1)/5, # El tamaño de los nodos basado en su in degree
       col=adjustcolor(V(net_name)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
       pch = V(net_name)$shape_comun, # La forma de mis nodos basada en su comunidad
       xlim=c(-60, 160),ylim=c(-100,60), # Para que todos ocupen el mismo espacio
       xlab="", ylab="", axes=T)
  title(paste0(hashtags_opo[i]))
}
dev.off()

png(filename ="duque_activacion_hashtags_gob.png", width = 15, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
par(mfrow = c(2,5))
for(i in 1:length(hashtags_gob)){ # digo a R que repita esta operación por el largo de mi objecto
  # selecciones los edges que mencionan a ese usuario
  select_edges <-which(str_detect(E(duque_sub)$text,hashtags_gob[i]))
  # esos edges los extraigo de mi red
  net_name <- subgraph.edges(duque_sub, eids = select_edges, delete.vertices = TRUE)
  # grafico
  plot(cbind(-V(net_name)$l2,-V(net_name)$l1), # Mis coordenadas del layout
       cex=log(V(net_name)$in_degree+1)/5, # El tamaño de los nodos basado en su in degree
       col=adjustcolor(V(net_name)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
       pch = V(net_name)$shape_comun, # La forma de mis nodos basada en su comunidad
       xlim=c(-60, 160),ylim=c(-100,60), # Para que todos ocupen el mismo espacio
       xlab="", ylab="", axes=T)
  title(paste0(hashtags_gob[i]))
}
dev.off()

## Hipervínculos

# Vamos a extraer los hipervínculos (urls) más comunes de cada comunidad

medio <- duque_sub_df %>%
  filter(!is.na(urls)) %>%
  mutate(medio = str_extract(urls,".*\\."),
         medio = str_remove(medio,"\\.")) %>%
  group_by(from_comunidad) %>%
  add_count(medio, name = "num_medio", sort = T) %>%
  distinct(medio,num_medio,.keep_all = T) %>%
  top_n(15)

medio_opo <- head(medio$medio[medio$from_comunidad == "Oposición"], n=5)
medio_gob <- head(medio$medio[medio$from_comunidad == "Gobierno"], n=5)

png(filename ="duque_activacion_medios_opo.png", width = 15, height = 5, units = "in", pointsize = 12, bg = "white", res = 300)
par(mfrow = c(1,5))
for(i in 1:length(medio_opo)){ # digo a R que repita esta operación por el largo de mi objecto
  # selecciones los edges que mencionan a ese usuario
  select_edges <-which(str_detect(E(duque_sub)$urls,medio_opo[i]))
  # esos edges los extraigo de mi red
  net_name <- subgraph.edges(duque_sub, eids = select_edges, delete.vertices = TRUE)
  # grafico
  plot(cbind(-V(net_name)$l2,-V(net_name)$l1), # Mis coordenadas del layout
       cex=log(V(net_name)$in_degree+1)/5, # El tamaño de los nodos basado en su in degree
       col=adjustcolor(V(net_name)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
       pch = V(net_name)$shape_comun, # La forma de mis nodos basada en su comunidad
       xlim=c(-60, 160),ylim=c(-100,60), # Para que todos ocupen el mismo espacio
       xlab="", ylab="", axes=T)
  title(paste0(medio_opo[i]))
}
dev.off()

png(filename ="duque_activacion_medios_gob.png", width = 15, height = 5, units = "in", pointsize = 12, bg = "white", res = 300)
par(mfrow = c(1,5))
for(i in 1:length(medio_gob)){ # digo a R que repita esta operación por el largo de mi objecto
  # selecciones los edges que mencionan a ese usuario
  select_edges <-which(str_detect(E(duque_sub)$urls,medio_gob[i]))
  # esos edges los extraigo de mi red
  net_name <- subgraph.edges(duque_sub, eids = select_edges, delete.vertices = TRUE)
  # grafico
  plot(cbind(-V(net_name)$l2,-V(net_name)$l1), # Mis coordenadas del layout
       cex=log(V(net_name)$in_degree+1)/5, # El tamaño de los nodos basado en su in degree
       col=adjustcolor(V(net_name)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
       pch = V(net_name)$shape_comun, # La forma de mis nodos basada en su comunidad
       xlim=c(-60, 160),ylim=c(-100,60), # Para que todos ocupen el mismo espacio
       xlab="", ylab="", axes=T)
  title(paste0(medio_gob[i]))
}
dev.off()



