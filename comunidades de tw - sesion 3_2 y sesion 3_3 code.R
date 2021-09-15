
# Sesion 3: Detección de comunidades
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

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

# V(duque_sub)$comunidad <- duque_communidades$membership # Agrego la información sobre las comunidades
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

# setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")
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

nodos_top <-which(V(duque_sub)$membership==as.numeric(top_mem[1]) |
                    V(duque_sub)$membership==as.numeric(top_mem[3]))

duque_sub <- induced.subgraph(graph=duque_sub,vids=nodos_top)

## Ahora queremos graficar estas comunidades (FINALMENTE) ----
## Vamos a utilizar un algoritmo para el layout llamado  Fruchterman-Reingold

# layout_duque <- layout_with_fr(duque_sub, grid = c("nogrid")) # No correr!

# V(duque_sub)$l1<-layout_sub[,1] # Coordenadas en dimension 1
# V(duque_sub)$l2<-layout_sub[,2] # Coordenadas en dimension 2

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Data")
# save(duque_sub, file = "duque_sub_layout.Rdata")
load("duque_sub_layout.Rdata")

## Graficamos:

V(duque_sub)$col_comun <- ifelse(V(duque_sub)$membership == 4, "royalblue3", "tomato3")
V(duque_sub)$shape_comun <- ifelse(V(duque_sub)$membership == 4, 19, 17)

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Figuras")

png(filename ="duque_net_com.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(V(duque_sub)$l1*2.5,V(duque_sub)$l2*2.5),cex=log(V(duque_sub)$ind+1)/10, 
     col=adjustcolor(V(duque_sub)$col_comun, alpha.f = .25), # xlim=c(140,-130),ylim=c(60,-50),
     xlab="", ylab="", axes=FALSE, pch = V(duque_sub)$shape_comun)
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("royalblue3", "tomato3"))
dev.off()

## Ahora tiene más sentido... 

## Volvamos a estimar el grado de centralidad y veamos cómo es en nuestro nuevo gráfico

V(duque_sub)$in_degree <- degree(duque_sub, mode = "in")

cols=setNames(colorRampPalette(c("grey96", "royalblue3"))(length(unique(V(duque_sub)$in_degree))), sort(unique(V(duque_net)$in_degree))) 
V(duque_sub)$col_degree <- cols[as.character(V(duque_sub)$in_degree)]

png(filename ="duque_net_com_in.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(V(duque_sub)$l1*2.5,V(duque_sub)$l2*2.5),cex=log(V(duque_sub)$ind+1)/10, 
     col=adjustcolor(V(duque_sub)$col_degree, alpha.f = .25), # xlim=c(140,-130),ylim=c(60,-50),
     xlab="", ylab="", axes=FALSE, pch = V(duque_sub)$shape_comun)
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("black", "black"))
dev.off()

## Veamos los verified:
V(duque_sub)$col_veri <- ifelse(V(duque_sub)$verified == T, "royalblue3", "gray96")
V(duque_sub)$shape_veri <- ifelse(V(duque_sub)$verified == T, 19, 17)

png(filename ="duque_net_com_ver.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot(cbind(V(duque_sub)$l1*2.5,V(duque_sub)$l2*2.5),cex=log(V(duque_sub)$ind+1)/10, 
     col=adjustcolor(V(duque_sub)$col_veri, alpha.f = .5), # xlim=c(140,-130),ylim=c(60,-50),
     xlab="", ylab="", axes=FALSE, pch = V(duque_sub)$shape_veri)
legend("bottomright", c("Verificado","Plebe"), pch = c(19,17), col=c("royalblue3", "gray96"))
dev.off()

## ¿Dónde están exactamente los importantes?

V(duque_sub)$importantes <- ifelse(V(duque_sub)$name == "HELIODOPTERO" |
                                    V(duque_sub)$name == "FisicoImpuro" |
                                    V(duque_sub)$name == "petrogustavo" |
                                     V(duque_sub)$name == "RevistaSemana" |
                                     V(duque_sub)$name == "jflafaurie" |
                                     V(duque_sub)$name == "JEAM_79",1,0)

png(filename ="duque_net_com_ver.png", width = 10, height = 10, units = "in", pointsize = 12, bg = "white", res = 300)
plot.igraph(duque_sub,vertex.label= ifelse(V(duque_sub)$importantes == 1, V(duque_sub)$name, ""), layout=cbind(V(duque_sub)$l1*3.5,V(duque_sub)$l2*3.5), 
            vertex.size=log(V(duque_sub)$ind+1)/7.5, vertex.label.color="black", vertex.label.cex = 0.4, 
            vertex.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .25), 
            vertex.frame.color=adjustcolor(V(duque_sub)$col_degree, alpha.f = .25),
            edge.color = NA , vertex.label.cex=1,  edge.curved=TRUE,  asp = 0, ylim=c(-.5,.5),xlim=c(-.5,.5))
legend("bottomright", c("Oposición","Gobierno"), pch = c(19,17), col=c("black", "black"))
dev.off()

## Guardamos y nos vamos!
save(duque_sub, file = "duque_sub_com.Rdata")




