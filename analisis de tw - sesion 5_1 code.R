
# Sesion 5: Análisis de la red III
# Instructor: Sebastián Vallejo Vera

## Carga las bibliotecas necesarias: ----

rm(list = ls(all=TRUE)) # Esta función limpia mi environment

library(tidyverse) # tidyverse nos ayuda con la minupulación de datos
library(tidylog) # para saber qué está pasando con tidyverse
library(RColorBrewer) # RColorBrewer nos da colores bonitos
library(igraph) # Con igraph creamos y evaluamos nuetra red
library(survival) # Para correr el Cox
library(stargazer) # Para hacer tablas bonitas... 
library(survminer) # Para predicciones bonitas.. 

## Cargamos nuestra red: ----

setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Data")
load("duque_sub_com.Rdata")

## Tiempo de RT: ----
E(duque_sub)$tiempo_RT <- E(duque_sub)$time_hub - E(duque_sub)$time_auto
duque_sub_df <- as_long_data_frame(duque_sub) # Primero lo convierto en df para poder estimar el EI

## Veamos qué nos puede decir sobre nuestras comunidades:

duque_sub_df$from_comunidad <- ifelse(duque_sub_df$from_comunidad==4, "Oposición","Gobierno")
duque_sub_df$tiempo_RT_corto <- ifelse(duque_sub_df$tiempo_RT>30000,NA,duque_sub_df$tiempo_RT)
duque_sub_df$from_followers_log <- log(duque_sub_df$from_followers+1)
duque_sub_df$to_followers_log <- log(duque_sub_df$to_followers+1)
duque_sub_df$from_in_degree_log <- log(duque_sub_df$from_in_degree+1)
duque_sub_df$to_in_degree_log <- log(duque_sub_df$to_in_degree+1)

duque_cox_opo <- coxph(Surv(tiempo_RT_corto) ~ 
                     from_followers_log + 
                     from_verified + from_in_degree_log + 
                     to_followers_log + 
                     to_verified + to_in_degree_log, 
                   data = subset(duque_sub_df,duque_sub_df$from_comunidad=="Oposición") )

summary(duque_cox_opo)

duque_cox_gob <- coxph(Surv(tiempo_RT_corto) ~ 
                         from_followers_log + 
                         from_verified + from_in_degree_log + 
                         to_followers_log + 
                         to_verified + to_in_degree_log, 
                       data = subset(duque_sub_df,duque_sub_df$from_comunidad=="Gobierno") )

summary(duque_cox_gob)

## pongamos esto en una tabla: 
setwd("/Users/sebastian/OneDrive - University Of Houston/Workshops and Courses/Redes sociales - U Sergio Arboleda/Tablas")

iv.names <-c("Seguidores (hub)", 
             "Verificado (hub)",
             "In-degree (hub)",
             "Seguidores (autoridad)",
             "Verificado (autoridad)",
             "In-degree (autoridad)", 
             "Comunidad Oposición (hub)")

stargazer(duque_cox_opo,duque_cox_gob, title="", align=TRUE, 
          dep.var.caption  = "Tiempo-a-RT",
          column.labels = c("Oposición","Gobierno"),
          style="apsr",
          type="html", covariate.labels  = iv.names, 
          model.numbers = FALSE, 
          dep.var.labels = c("",""), out="duque_cox.html")

## Veamos qué activa a la red: ----

## Hashtags:
hashtags <- duque_sub_df %>%
  group_by(from_comunidad) %>%
  unnest_tokens(hashtags, text, "tweets", to_lower = F) %>%
  filter(str_detect(hashtags, "^#")) %>%
  add_count(hashtags, name = "num_hashtag", sort = T) %>%
  distinct(hashtags,num_hashtag,.keep_all = T) %>%
  top_n(15)

hashtags_opo <- head(hashtags$hashtags[hashtags$from_comunidad == "Oposición"], n=10)
hashtags_gob <- head(hashtags$hashtags[hashtags$from_comunidad == "Gobierno"], n=10)

duque_sub_df$DuqueSaboteaAlMagdalena <- str_detect(duque_sub_df$text,hashtags_opo[1])
duque_sub_df$ElMajadero <- str_detect(duque_sub_df$text,hashtags_opo[2])
duque_sub_df$ReformaTributaria <- str_detect(duque_sub_df$text,hashtags_opo[3])
duque_sub_df$SanAndrés <- str_detect(duque_sub_df$text,hashtags_opo[8])
duque_sub_df$LosDanieles <- str_detect(duque_sub_df$text,hashtags_opo[10])

duque_sub_df$EncuestaSemana <- str_detect(duque_sub_df$text,hashtags_gob[1])
duque_sub_df$CabalPresidente2022 <- str_detect(duque_sub_df$text,hashtags_gob[2])
duque_sub_df$MinTic <- str_detect(duque_sub_df$text,hashtags_gob[3])
duque_sub_df$SoyCabal <- str_detect(duque_sub_df$text,hashtags_gob[5])
duque_sub_df$ElChavezDeColombia <- str_detect(duque_sub_df$text,hashtags_gob[10])

duque_cox_opo_hashtags <- coxph(Surv(tiempo_RT_corto) ~ 
                         from_followers_log + 
                         from_verified + from_in_degree_log + 
                         to_followers_log + 
                         to_verified + to_in_degree_log +
                         DuqueSaboteaAlMagdalena +
                         ElMajadero +
                         ReformaTributaria +
                         SanAndrés +
                         LosDanieles, 
                       data = subset(duque_sub_df,duque_sub_df$from_comunidad=="Oposición") )

summary(duque_cox_opo_hashtags)

duque_cox_gob_hashtags <- coxph(Surv(tiempo_RT_corto) ~ 
                         from_followers_log + 
                         from_verified + from_in_degree_log + 
                         to_followers_log + 
                         to_verified + to_in_degree_log +
                         EncuestaSemana +
                         CabalPresidente2022 +
                         MinTic +
                         SoyCabal +
                         ElChavezDeColombia , 
                       data = subset(duque_sub_df,duque_sub_df$from_comunidad=="Gobierno") )

summary(duque_cox_gob_hashtags)

## urls

medio <- duque_sub_df %>%
  filter(!is.na(urls)) %>%
  mutate(medio = str_extract(urls,".*\\."),
         medio = str_remove(medio,"\\.")) %>%
  group_by(from_comunidad) %>%
  add_count(medio, name = "num_medio", sort = T) %>%
  distinct(medio,num_medio,.keep_all = T) %>%
  top_n(15)

medio_opo <- head(medio$medio[medio$from_comunidad == "Oposición"], n=10)
medio_gob <- head(medio$medio[medio$from_comunidad == "Gobierno"], n=10)

duque_sub_df$pluralidadz <- str_detect(duque_sub_df$urls,medio_opo[1])
duque_sub_df$infobae <- str_detect(duque_sub_df$urls,medio_opo[2])
duque_sub_df$elespectador <- str_detect(duque_sub_df$urls,medio_opo[3])
duque_sub_df$washingtonpost <- str_detect(duque_sub_df$urls,medio_opo[4])
duque_sub_df$losdanieles <- str_detect(duque_sub_df$urls,medio_opo[5])

duque_sub_df$semana <- str_detect(duque_sub_df$urls,medio_gob[1])
duque_sub_df$lafmcom <- str_detect(duque_sub_df$urls,"lafm")
duque_sub_df$bluradio <- str_detect(duque_sub_df$urls,medio_gob[4])
duque_sub_df$idmpresidencia <- str_detect(duque_sub_df$urls,"presidencia")
duque_sub_df$rcnradio <- str_detect(duque_sub_df$urls,medio_gob[7])

duque_cox_opo_urls <- coxph(Surv(tiempo_RT_corto) ~ 
                                  from_followers_log + 
                                  from_verified + from_in_degree_log + 
                                  to_followers_log + 
                                  to_verified + to_in_degree_log +
                                  pluralidadz +
                                  infobae +
                                  elespectador +
                                  washingtonpost +
                                  losdanieles, 
                                data = subset(duque_sub_df,duque_sub_df$from_comunidad=="Oposición") )

summary(duque_cox_opo_urls)

duque_cox_gob_urls <- coxph(Surv(tiempo_RT_corto) ~ 
                                  from_followers_log + 
                                  from_verified + from_in_degree_log + 
                                  to_followers_log + 
                                  to_verified + to_in_degree_log +
                                  semana +
                                  lafmcom +
                                  bluradio +
                                  idmpresidencia +
                                  rcnradio , 
                                data = subset(duque_sub_df,duque_sub_df$from_comunidad=="Gobierno") )

summary(duque_cox_gob_urls)

iv.names <-c("Seguidores (hub)", 
             "Verificado (hub)",
             "In-degree (hub)",
             "Seguidores (autoridad)",
             "Verificado (autoridad)",
             "In-degree (autoridad)", 
             "DuqueSaboteaAlMagdalena",
             "ElMajadero",
             "ReformaTributaria",
             "SanAndrés",
             "LosDanieles",
             "EncuestaSemana",
             "CabalPresidente2022",
             "MinTic",
             "SoyCabal",
             "ElChavezDeColombia",
             "pluralidadz",
             "infobae",
             "elespectador",
             "washingtonpost",
             "losdanieles",
             "semana",
             "lafmcom",
             "bluradio",
             "idmpresidencia",
             "rcnradio")

stargazer(duque_cox_opo_hashtags,duque_cox_gob_hashtags,
          duque_cox_opo_urls, duque_cox_gob_urls,
          title="", align=TRUE, 
          dep.var.caption  = "Tiempo-a-RT",
          column.labels = c("Oposición","Gobierno","Oposición","Gobierno"),
          style="apsr",
          type="html", covariate.labels  = iv.names, 
          model.numbers = FALSE, 
          dep.var.labels = c("",""), out="duque_cox_acti.html")

## Grafiquemos las diferencias de activación de autoridades y hubs:

new_df <- with(duque_cox_opo_hashtags, # Creamos un nuevo df para ver las predicciones
               data.frame(from_followers_log=rep(mean(duque_sub_df$from_followers_log, na.rm=TRUE),4), 
                          from_verified=c(F,F,F,F), 
                          from_in_degree_log=c(1, 6, 1, 6), # Variamos si es high o low hub
                          to_followers_log=rep(mean(duque_sub_df$to_followers_log, na.rm=TRUE),4), 
                          to_verified=c(F,F,F,F), 
                          to_in_degree_log=rep(mean(duque_sub_df$to_in_degree_log, na.rm = TRUE),4),
                          DuqueSaboteaAlMagdalena=c(F,F,T,T), 
                          ElMajadero=c(F,F,F,F),
                          ReformaTributaria=c(F,F,F,F), # Variamos el hashtag
                          SanAndrés=c(F,F,F,F),
                          LosDanieles=c(F,F,F,F)
                          
               )
)

duque_cox_opo_hashtags_fit <- survfit(duque_cox_opo_hashtags, newdata=new_df)

ggsurvplot(duque_cox_opo_hashtags_fit, data=duque_sub_df, ## Graficamos
                 conf.int = F, palette = "lancet",
                 censor = TRUE,
                 legend.labs=c("Sin DuqueSabotea\nLow-Degree Hub", "Sin DuqueSabotea\nHigh-Degree Hub",
                               "DuqueSabotea\nLow-Degree Hub", "DuqueSabotea\nHigh-Degree Hub"),
                 conf.int.style="step",
                 legend = "bottom", 
                 break.time.by = 5000, 
                 surv.median.line = "hv", 
                 xlab="Time-to-Reweet", 
                 legend.title="")
