---
title: Práctica Lex
author: Paula Villanueva Núñez
date: \today
---

# Objetivo

El objetivo de esta práctica es convertir un archivo Markdown a un archivo LaTeX. Es mucho más cómodo y fácil escribir en markdown 
que en LaTeX en muchas ocasiones, ya que no tiene tantos comandos ni paquetes. Por lo que si tenemos un documento escrito en LaTeX
y no sabemos escribir en dicho lenguaje, podemos convertirlo a markdown, que es mucho más sencillo.

# Descripción
Esta herramienta permite convertir los comandos más básicos de LaTeX (título, autor, fecha, formato de texto (negrita, cursiva, subrayado...), listas, imágenes, links, secciones, comentarios, ecuaciones...) en comandos de Markdown.

Por ejemplo, las palabras en negrita en LaTeX tienen el comando `\textbf`, por lo que he usado la expresión regular
`"\\textbf{"[^"}"]*"}"`. Esta expresión regular coge todos los caracteres comprendidos entre `\textbf{` y `}` y llama a la correspondiente función para que lo convierta a lenguaje Markdown, en este caso sería poner el texto entre doble asterisco.

Para el resto de comandos me he basado en la misma idea y se puede consultar en el código adjuntado.

# Uso

Veamos cómo funciona esta herramienta. He adjuntado el archivo `Ejemplo_latex.tex` en el que incluyo los comandos más básicos y utilizados a la hora de programar el LaTeX. Para comprobar el correcto funcionamiento de esta herramienta, podemos ejecutar el archivo `Makefile.sh`, el cual convierte el archivo en LaTeX a Markdown, crea un PDF para el archivo en LaTeX y crea otro PDF para el archivo en Markdown y así poder ver las diferencias.

> Nota. Para compilar, hay que tener instalado `texlive-latex` y `pandoc`.