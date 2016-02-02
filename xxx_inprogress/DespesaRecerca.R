library(ggplot2)
dades<-read.table("/Users/guillemsalazar/Desktop/DespesaRecerca.txt",sep="\t",header=T,fileEncoding="UTF-8")
dades$Despesa<-dades$Despesa

ggplot(dades, aes(x=Any, y=Milers,color=Desti)) +
  geom_point(,size=4) +
  geom_line(,size=1) +
  facet_wrap( ~ Tipus,scales="free_y") +
  #scale_y_log10() +
  ylab("Despesa (1000 euros)")

ggplot(dades, aes(x=Any, y=Milers,color=Tipus)) +
  geom_point(,size=4) +
  geom_line(,size=1) +
  facet_wrap( ~ Desti,scales="free_y") +
  #scale_y_log10() +
  ylab("Despesa (1000 euros)")


dades.suma.desti<-aggregate(dades$Milers,by=list(Any=dades$Any,Tipus=dades$Tipus),sum)
ggplot(dades.suma.desti, aes(x=Any, y=x,color=Tipus)) +
  geom_point(,size=4) +
  geom_line(,size=1) +
  #facet_wrap( ~ Tipus,scales="free_y") +
  #scale_y_log10() +
  ylab("Despesa (1000 euros)")

dades.suma.tipus<-aggregate(dades$Milers,by=list(Any=dades$Any,Desti=dades$Desti),sum)
ggplot(dades.suma.tipus, aes(x=Any, y=x,color=Desti)) +
    geom_point(,size=4) +
    geom_line(,size=1) +
  facet_wrap( ~ Desti,scales="free_y") +
  #scale_y_log10() +
  ylab("Despesa (1000 euros)")
  