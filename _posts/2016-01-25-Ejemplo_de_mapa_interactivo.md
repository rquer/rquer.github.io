---
layout: posts
title: "Ejemplo de mapa interactivo: histórico de seísmos en la Península Ibérica"
author: "Guillem Salazar"
---

Lo prometido es deuda!

Después de largos meses con un solo post en el blog y sin actividad, **RqueR Blog** vuelve con una renovada estructura (nos hemos mudado a [GitHub](https://github.com/rquer)) y con los mapas interactivos prometidos como segundo post.

Si en el primer post aprendimos como hacer mapas estáticos con el paquete *ggmap* hoy es hora de aprender a construir mapas dinámicos. Aprovecharemos la herramienta [*Leaflet*](http://leafletjs.com/) y el paquete homónimo de R.

Usaremos, a modo de ejemplo, el histórico de datos de seísmos en la Península Ibérica del [Instituto Geográfico Nacional](http://www.ign.es/ign/main/index.do). Concretamente usaremos el catálogo de terremotos que podéis encontrar en su versión original [aquí](http://www.ign.es/ign/layoutIn/sismoFormularioCatalogo.do). O bien, en el GitHub del blog con un formato mas amable (texto separado por tabuladores, [aquí](https://raw.githubusercontent.com/rquer/rquer.github.io/master/files/terremotos.txt)) que será el que usemos en adelante. Estos últimos consisten en un archivo con las siguientes variables para cada terremoto producido desde 1370:

- **Evento** (código numérico para cada seísmo)
- **Fecha**
- **Hora**
- **Longitud**
- **Latitud**
- **Mag** (magnitud del seísmo)




###Cargado de datos
El primer paso será cargar los datos y visualizarlos:

```r
datos<-read.table("https://raw.githubusercontent.com/rquer/rquer.github.io/master/files/terremotos.txt",sep="\t",header=T)
```

Para disminuïr la cantidad de datos a visualizar, filtraremos (y guardamos como un objeto separado, *datos.red*) solo aquellos terremotos con una magnitud mayor a 5.

```r
datos.red<-datos[which(datos$Mag>5),]
```

###Uso del paquete *leaflet*

En caso de no tener instalado el paquete *leaflet* podemos instalarlo con:

```r
install.packages("leaflet")
```

Y lo cargamos:

```r
library(leaflet)
```

El mapa mas simple que podemos crear es un mapa con un punto por seísmo con las opciones que vienen por defecto. Para ello debemos introducir la Longitud y Latitud.

```r
m<-leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lng=datos.red$Longitud, lat=datos.red$Latitud)
m
```

<div class="container">
    <iframe src="/figures/Leaflet_map1.html" height="315" width="560" allowfullscreen="" frameborder="0">
    </iframe>
</div>

###Opciones adicionales

Una infinidad de opciones pueden ser especificadas para modificar el mapa o la visualización de los datos. A modo de ejemplo, podemos:

1. Establecer el radio de los círculos proporcional a la magnitud del seísmo.
2. Cambiar el color de los puntos.
3. Añadir cuadros de información a los puntos que se muestran al pulsarlos con el ratón.

El argumento *radius* determina el tamaño de los círculos. El argumento *stroke* puede fijarse como *FALSE* para eliminar el contorno de los puntos. Y el argumento *color* y *fillOpacity* determinan el color y opacidad de estos mismos. Así, si queremos los seísmos representados como puntos rojos semitransparentes y de radio proporcional a su magnitus:

```r
m<-leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lng=datos.red$Longitud, lat=datos.red$Latitud,radius=datos.red$Mag,stroke=F,color="red",fillOpacity=0.5)
m
```

<div class="container">
    <iframe src="/figures/Leaflet_map2.html" height="315" width="560" allowfullscreen="" frameborder="0">
    </iframe>
</div>


Anteriormente hemos filtrado los datos para considerar los seísmos de magnitud mayor a 5. A continuación incluiremos todos los seísmos con magnitudes mayor a 3 y añadiremos un cuadro de información a cada punto que se muestran al pulsarlo con el ratón. Para ello debemos crear un vector de texto concatenando la información a incluir (en nuestro caso la *fecha*, *hora* y *magnitud* del seísmo). Este vector lo añadimos a los datos como una nueva variable, llamada *info*.

```r
datos.red<-datos[which(datos$Mag>3),]
datos.red$info<-paste("Fecha: ",datos.red$Fecha, ", Hora: ",datos.red$Hora,", Magnitud: ",datos.red$Mag,sep="")
```

Para añadir los cuadros de información usamos el argumento *popup* donde introduciremos la nueva variable creada. También podemos cambiar el mapa base usando *addTiles*. Podemos usar diferentes mapas especificando una *url* válida. Algunas pueden pre-visualizarse [aquí](http://leaflet-extras.github.io/leaflet-providers/preview/). Solo hay que copiar la web indicada en la primera linea del pequeño script de la cabezera del mapa deseado. Nosotros usaremos un mapa topográfico llamado **OpenTopoMap**. 

```r
m<-leaflet() %>%
  addTiles(urlTemplate="http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png") %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=datos.red$Longitud, lat=datos.red$Latitud,radius=datos.red$Mag/2,popup=datos.red$info,stroke=F,color="red",fillOpacity=0.5)
m
```

<div class="container">
    <iframe src="/figures/Leaflet_map3.html" height="315" width="560" allowfullscreen="" frameborder="0">
    </iframe>
</div>


Si hacemos click en un punto podremos ver la información del seísmo en forma de cuadro de texto.
Esta imagen evidencia que el mar de Alborán, [donde se ha producido un terremoto](http://politica.elpais.com/politica/2016/01/25/actualidad/1453697500_397724.html) es una zona de fuertes seísmos dentro de la Península y se visualiza claramente la zona de colisión de la placa Africana con la placa Euroasiática.

###Mas recursos:
1. [Tutorial](http://leafletjs.com/examples.html) y [documentación](http://leafletjs.com/reference.html) oficial de **Leaflet**
2. [Pre-visualizador de mapas disponibles](http://leaflet-extras.github.io/leaflet-providers/preview/)
