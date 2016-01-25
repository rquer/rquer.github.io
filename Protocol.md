#Prepare a Post

1. Create a *.Rmd* file within *_rmd* folder with RStudio.
2. Name it as **Year-Month-Day-This_is_the_title.Rmd**
3. Use the proper header (see below).
4. Run the **rmd2md.R** script: An *.md* file is created within *_posts* folder and images are converted to *.png* files and saved within *figures* folder.
5. If this is the final version change the published parameter to *true* and change the status parameter to *publish* (so it won't be processed anymore).
6. Add and commit changes.

Header:

```
---
layout: posts
title: "Available genomes through time"
author: "Guillem Salazar"
published: false
status: process
draft: false
---
```

Run **rmd2md.R**

```
source("/Users/guillemsalazar/Documents/RqueRblog/rmd2md.R")
setwd("/Users/guillemsalazar/Documents/RqueRblog")
rmd2md()
```


#Upload to GitHub

##For the First time

```
cd /Users/guillemsalazar/Documents/RqueRblog
git config user.email "rquerblog@gmail.com"
git add -A
git commit -a -m "Your message"
git remote add origin git@rquer.github.com:rquer/rquer.github.io.git
git push origin master
```

##A new post

```
cd /Users/guillemsalazar/Documents/RqueRblog
git add -A
git commit -a -m "Your message"
git push origin master
```