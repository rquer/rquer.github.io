---
layout: posts
title: "Captura de tweets con R y el paquete twitteR (ejemplo Mobile World Congress 2015)"
date: 2015-03-08
---

Para estrenar el blog voy a empezar mostrando la utilidad del paquete de R *twitteR*, que permite interaccionar con la API de la conocida red social. Existen diferentes funciones en este paquete pero voy a explotar, a modo de inicio, las posibilidades de la función *searchTwitter()*.

Consiste en una función que interactua con la API de Twitter y devuelve los tweets publicados en un pasado reciente (alrededor de los últimos 7 días). Vamos a utilizar esta función para capturar los tweets publicados en la ciudad de Barcelona durante el Mobile World Congress 2015 que se desarrolló recientemente en esta ciudad. Para ello vamos a capturar los tweets publicados en un rango de 10 km desde el centro de Barcelona que contengan el hashtag **#MWC15**. A modo de ejemplo, haremos un par de visualizaciones de la evolución del número de tweets a lo largo de la semana y de la localización de estos tweets en la ciudad.

Para la instalación del paquete *twitteR* y cargarlo en memoria:


```
install_github("twitteR", username="geoffjentry")
library(twitteR)
```

La API de Twitter es abierta pero necesita de autentificación. Para que el paquete *twitteR* pueda interactuar con la API de Twitter necesitamos autentificarnos. Para ello debemos ir a https://apps.twitter.com/app/new y rellenar los pasos necesarios para conseguir las llamadas "consumer key", "consumer secret", "access token" y "access secret". Nos servirán en el siguiente paso:

```
setup_twitter_oauth("consumer key", "consumer secret", "access token", "access secret")
```

Si todo ha funcionado bien deberíamos leer el mensaje **Using direct authentication** en la consola de R. Una vez autentificados podemos empezar a usar  la función *searchTwitter()*. Para el siguiente ejemplo capturaremos todos los tweets de la última semana que contengan el texto MWC15 y que se hallen a 10 km del centro de Barcelona. Estos son los parámetros que tomará la función. Con la segunda linea convertimos los datos en un 'data frame':

```
string<-"MWC15"
res<-searchTwitter(string,n=20000,geocode='41.390880,2.174077,10km')
resDF<-twListToDF(res)
```

Ahora debemos convertir la latitud y longitud en variables numéricas:

```
resDF$longitude<-as.numeric(resDF$longitude)
resDF$latitude<-as.numeric(resDF$latitude)
```

Estamos listos para visualizar el posicionamiento de, en este caso, 5,970 tweets capturados entre el 01/03/2015 y el 06/03/2015. Usaremos el paquete *ggplot2* y *ggmap* para los gráficos:

```
library(ggmap)
map<-ggmap(get_map("Barcelona",zoom=13),extent="device")
map + geom_point(data = resDF, aes(x=longitude ,y=latitude),cex=1.2,alpha=0.4,color="red") +
guides(alpha=FALSE)
```

![Map](/files/Map.png)

Podemos añadir la densidad de tweets para tener una idea de donde se concentra la mayor proporción de los tweets:

```
map +
stat_density2d(data = resDF, aes(x = longitude, y = latitude,  fill = ..level.., alpha = ..level..), bins = 30, geom = 'polygon',n=100) +
scale_fill_gradient(low = rgb(0,0,1), high = rgb(0,0,1)) +
geom_point(data = resDF, aes(x=longitude ,y=latitude),col=rgb(1,0,0,0.4),cex=1) +
theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))
```

![Map_density](/files/Map_density.png)

Finalmente, podemos visualizar también la evolución del número de tweets a lo largo de la semana. El título del gráfico toma la información del texto buscado y definido anteriormente y del número de tweets capturados:

```
dev.new(width=8,height=5)
ggplot(resDF, aes(created)) +
geom_area(aes(y=..count..), stat = "bin",binwidth=3000) +
ggtitle(paste("Search:",paste(string,collapse=" & "),"||",dim(resDF)[1],"geolocalized TW retrieved")) +
theme(plot.title = element_text(lineheight=.4, face="bold",size=10))
```

![Dynamics](/files/Dynamics.png)