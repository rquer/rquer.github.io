---
layout: default
title: RqueR Blog
---


###Análisis y visualización de datos abiertos con R
 
####Uno empieza aprendiendo R para hacer una Tesis en Ecología Microbiana y se encuentra con un S.XXI lleno de datos abiertos esperando ser torturados, las herramientas para analizarlos y la distracción necesaria para dedicarle un poco de "tiempo libre".  
 
####Que aproveche.



<ul class="posts">
	{% for post in site.posts %}
	<li><span>{{ post.date | date_to_string }}</span> » <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a></li>
	{% endfor %}
</ul>
