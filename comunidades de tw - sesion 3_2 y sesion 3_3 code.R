
# Sesion 3: Detección de comunidades
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

rm(list = ls(all=TRUE)) # Esta función limpia mi environment

library(tidyverse) # tidyverse nos ayuda con la minupulación de datos
library(tidylog) # para saber qué está pasando con tidyverse
library(RColorBrewer) # RColorBrewer nos da colores bonitos
library(igraph) # Con igraph creamos y evaluamos nuetra red

## Cargamos nuestra red: ----

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Data")
load("duque_layout.Rdata")

## Estimamos los comunidades: ----

## Primero vamos a eliminar los nodos de poca información:

nodos_drop <-which(V(duque_net)$out_degree >3 | V(duque_net)$in_degree >=1) # Elijo los nodos
duque_sub <- induced.subgraph(graph=duque_net,vids=nodos_drop) # Y creo una nueva red sin esos nodos

## Luego utilizo el algoritmo walktrap para identificar comunidades:

# duque_comunidades <- cluster_walktrap(duque_sub) # ¡No correr!

## Agreguemos esta info a nuestra red y exploremos las comunidades:

# V(duque_sub)$comunidad <- duque_communidades$comunidad # Agrego la información sobre las comunidades
# save(duque_sub,file="duque_sub.Rdata")

load("duque_sub.Rdata")

## Veamos un poco cuántas comunidades y que tan grandes son:

length(unique(V(duque_sub)$comunidad)) ## Uff son muchas
table(V(duque_sub)$comunidad) ## Pero hay muy pocas que contienen la mayoría de nodos...

## ¿Quiénes son? ----

## Los nodos más importante por comunidades

mis_colores <- brewer.pal(n=10, "RdBu") # Colores
mis_colores <- c(mis_colores,mis_colores)
top_mem <- as.numeric(rownames(sort(table(V(duque_sub)$comunidad),decreasing=T)[c(1:10)])) # Tomo el nombre de las comunidades más densas

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")
# 

for(i in 1:10){ # Esto es un loop... le digo a R que haga lo mismo varias veces (10 veces)
  d <- degree(induced.subgraph(graph=duque_sub, vids=which(V(duque_sub)$comunidad==top_mem[i])), mode="in") # In degree por comunidad
  d <- as.data.frame(sort(d,decreasing = FALSE)) # Ordeno por in degrees
  colnames(d) <- c("In_Degree") 
  png(paste("comunidad_duque_sept2021_",i,".png",sep=""), w=10, h=20,units = 'in',res=300) # Vamos a guardar como imagen
  par(mar=c(5,10,2,2))
  with(tail(d,n=30), barplot(In_Degree, names=tail(rownames(d),n=30), 
                             horiz=T, las=1, main=paste("Autoridades: Top 30 - Comunidad ", top_mem[i], sep=""), 
                             col=mis_colores[i])) # La imagen
  dev.off()
}

## Los nodos más importantes nos dan pistas sobre quiénes pertenecen a cada comunidad

## Escogemos las dos comunidades que seguramente están en Colombia 
## Las dos primeras (4 y 1) son oposición y gobierno (?)

nodos_top <-which(V(duque_sub)$comunidad==as.numeric(top_mem[1]) | 
                    V(duque_sub)$comunidad==as.numeric(top_mem[3]))

duque_sub <- induced.subgraph(graph=duque_sub,vids=nodos_top)

summary(duque_sub)
table(V(duque_sub)$comunidad)

## Ahora queremos graficar estas comunidades (FINALMENTE) ----
## Vamos a utilizar un algoritmo para el layout llamado  Fruchterman-Reingold

# layout_duque <- layout_with_fr(duque_sub, grid = c("nogrid")) # No correr!
# 
# V(duque_sub)$l1<-layout_sub[,1] # Coordenadas en dimension 1
# V(duque_sub)$l2<-layout_sub[,2] # Coordenadas en dimension 2

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Data")
# save(duque_sub, file = "duque_sub_layout.Rdata")
load("duque_sub_layout.Rdata")

## Graficamos:

V(duque_sub)$col_comun <- ifelse(V(duque_sub)$comunidad == 4, "darkblue", "darkred") # Diferencio el color por comunidad
V(duque_sub)$shape_comun <- ifelse(V(duque_sub)$comunidad == 4, 19, 17) # También doy diferentes formas

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")

png(filename ="duque_net_com.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300) # Baja resolución (sin edges)
plot(cbind(-V(duque_sub)$l2,-V(duque_sub)$l1), # Mis coordenadas del layout
     cex=log(V(duque_sub)$in_degree+1)/5, # El tamaño de los nodos basado en su in degree
     col=adjustcolor(V(duque_sub)$col_comun, alpha.f = .5), # El color de los nodos basado en su comunidad
     pch = V(duque_sub)$shape_comun, # La forma de mis nodos basada en su comunidad
     xlab="", ylab="", axes=T) # Si quiero poner algún nombre a los ejes aquí lo puedo hacer
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off()

## Ahora tiene más sentido... 

## Volvamos a estimar el grado de centralidad y veamos cómo es en nuestro nuevo gráfico

V(duque_sub)$in_degree <- degree(duque_sub, mode = "in") # Centralidad

cols_opo=setNames(colorRampPalette(c("aliceblue", "darkblue"))(length(unique(log(V(duque_sub)$in_degree+1)/5))), sort(unique(log(V(duque_sub)$in_degree+1)/5))) 
cols_gob=setNames(colorRampPalette(c("mistyrose", "darkred"))(length(unique(log(V(duque_sub)$in_degree+1)/5))), sort(unique(log(V(duque_sub)$in_degree+1)/5))) 

V(duque_sub)$col_degree <- ifelse(V(duque_sub)$comunidad == 4,
                                  cols_opo[as.character(log(V(duque_sub)$in_degree+1)/5)],
                                  cols_gob[as.character(log(V(duque_sub)$in_degree+1)/5)])

png(filename ="duque_net_com_in.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(-V(duque_sub)$l2,-V(duque_sub)$l1),
     cex=log(V(duque_sub)$in_degree+1)/5, 
     col=adjustcolor(V(duque_sub)$col_degree, alpha.f = .5), # El color de los nodos basado en su comunidad e indegree
     pch = V(duque_sub)$shape_comun, 
     xlab="", ylab="", axes=T) 
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off()

## Veamos los verified:
V(duque_sub)$col_veri <- ifelse(V(duque_sub)$verified == T, "darkgreen", "gray96")
V(duque_sub)$shape_veri <- ifelse(V(duque_sub)$verified == T, 19, 17)

png(filename ="duque_net_com_ver.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(-V(duque_sub)$l2,-V(duque_sub)$l1),
     cex=log(V(duque_sub)$in_degree+1)/5, 
     col=adjustcolor(V(duque_sub)$col_veri, alpha.f = .5), # El color de los nodos basado verificado
     pch = V(duque_sub)$shape_veri, # La forma de los nodos basada verificado
     xlab="", ylab="", axes=T)
legend("bottomright", c("Verificado","Plebe"), pch = c(19,17), col=c("darkgreen", "gray96"))
dev.off()

## ¿Dónde están exactamente los importantes?

V(duque_sub)$importantes <- ifelse(V(duque_sub)$name == "HELIODOPTERO" |
                                    V(duque_sub)$name == "FisicoImpuro" |
                                    V(duque_sub)$name == "petrogustavo" |
                                     V(duque_sub)$name == "RevistaSemana" |
                                     V(duque_sub)$name == "jflafaurie" |
                                     V(duque_sub)$name == "JEAM_79",1,0)

pdf(file = "duque_net_com_impor.pdf", 12, 6, pointsize=12, compress=TRUE) # Este es un high resolution... se demora
plot.igraph(duque_sub, # Uso otra función... plot.igraph!
            vertex.label= ifelse(V(duque_sub)$importantes == 1, V(duque_sub)$name, ""), # Me muestra los nombres solo los importantes
            layout=cbind(-V(duque_sub)$l2,-V(duque_sub)$l1), 
            vertex.size=log(V(duque_sub)$in_degree+1)/5, 
            vertex.label.color="black", vertex.label.cex = .25, # Tamaño y color de los nombres
            vertex.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .3), 
            vertex.frame.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .4),
            edge.color = "grey83" , edge.width=0.5, edge.arrow.size=0, # Colo y tamaño de los edges
            edge.curved=TRUE) # Si quiero que los edges sean curvos
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("darkblue", "darkred")) # Mi leyenda con los nombres correspondientes
dev.off() # Pesa 10 MB!

## Guardamos y nos vamos!
save(duque_sub, file = "duque_sub_com.Rdata")




